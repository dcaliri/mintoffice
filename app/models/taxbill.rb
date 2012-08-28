# encoding: UTF-8

class Taxbill < ActiveRecord::Base
  has_one :document, as: :owner

  belongs_to :taxman
  has_many :items, :class_name => 'TaxbillItem', :dependent => :destroy

  BILL_TYPE = [:purchase, :sale]

  include Historiable
  include Historiable
  include Reportable

  include SpreadsheetParsable
  include Excels::Taxbills::Purchase
  include Excels::Taxbills::Sale

  attr_accessor :document_id
  before_save :find_document_and_save

  def self.no_taxman_and_client
    Taxman.count == 0 and BusinessClient.count == 0
  end

  def self.oldest_at
    resource = order('transacted_at DESC').last
    if resource && resource.transacted_at
      resource.transacted_at
    else
      Time.zone.now
    end
  end

  def price
    items.sum{|item| item.price }
  end

  def tax
    items.sum{|item| item.tax }
  end

  def total
    items.sum{|item| item.total }
  end

  class << self
    def taxmen_list
      Taxman.all.map do |taxman|
        title = "#{taxman.fullname} / #{taxman.business_client.name}" rescue ""
        [title, taxman.id]
      end
    end

    def purchases
      where(billtype: "purchase")
    end

    def sales
      where(billtype: "sale")
    end

    def oldest_at
      resource = order('transacted_at DESC').last
      if resource && resource.transacted_at
        resource.transacted_at
      else
        Time.zone.now
      end
    end

    def total_tax
      sum{|taxbill| taxbill.tax }
    end

    def group_by_name_anx_tax
      all.group_by do |purchase|
        if purchase.taxman and purchase.taxman.business_client
          purchase.taxman.business_client.name
        else
          I18n.t('models.taxbill.etc')
        end
      end.map do |name, purchases|
        {
          name: name,
          tax: purchases.sum{|p| p.tax},
          price: purchases.sum{|p| p.price}
        }
      end
    end

    def search(params)
      search_billtype(params[:billtype]).
      search_taxmen(params[:taxman_id]).
      search_by_transacted(params[:transacted_at]).
      text_search(params[:query])
    end

    def text_search(text)
      unless text.blank?
        text = "%#{text}%"
        joins(:taxman => :business_client).merge(where("name like ?", text))
      else
        where("")
      end
    end

    def search_billtype(text)
      if text == "all" or text == nil
        where("")
      else
        where(billtype: text)
      end
    end

    def search_taxmen(text)
      if text == "0" or text == nil
        where("")
      else
        where(taxman_id: text)
      end
    end

    def search_by_transacted(text)
      if text == "0" or text == nil or text.blank?
        where("")
      else
        time = Time.zone.parse(text)
        where(transacted_at: (time..(time + 3.month)))
      end
    end

    def latest
      order("transacted_at DESC")
    end
  end

  def self.excel_parser(type)
    if type == :purchase
      purchase_taxbill_parser
    elsif type == :sale
      sale_taxbill_parser
    else
      raise "Cannot find excel parser. type = #{type}"
    end
  end

  def self.preview_stylesheet(type, upload)
    raise ArgumentError, I18n.t('common.upload.empty') unless upload
    path = file_path(upload['file'].original_filename)
    parser = excel_parser(type.to_sym)

    create_file(path, upload['file'])
    previews = []
    parser.parse(path) do |class_name, query, params|
      previews << TaxbillItem.new(params)
    end
    previews
  end

  def self.create_with_stylesheet(type, name)
    type = type.to_sym

    path = file_path(name)
    parser = excel_parser(type)

    transaction do
      parser.parse(path) do |class_name, query, params|
        items = TaxbillItem.where(query)

        if items.empty?
          if type == :purchase
            create_purchase_info(type, params)
          else
            create_sale_info(type, params)
          end
        else
          resource = items.first
          resource.update_attributes!(params)
        end
      end
    end
    File.delete(path)
  end

  def self.create_purchase_info(type, params)
    create_taxbill_from_excel(type, {
      name: params[:sellers_company_name],
      registration_number: params[:sellers_registration_number],
      email1: params[:seller_email],
      email2: nil,
    }, params)
  end

  def self.create_sale_info(type, params)
    create_taxbill_from_excel(type, {
      name: params[:buyers_company_name],
      registration_number: params[:buyer_registration_number],
      email1: params[:buyer1_email],
      email2: params[:buyer2_email],
    }, params)
  end

  def self.create_taxbill_from_excel(type, info, params)
    taxbill = Taxbill.new(billtype: type, transacted_at: params[:transacted_at])
    item = taxbill.items.build(params)

    client = BusinessClient.find_by_registration_number(info[:registration_number])
    unless client
      client = BusinessClient.new({
        name: info[:name],
        registration_number: info[:registration_number]
      })
    end

    taxman = client.taxmen.find_by_email([info[:email1], info[:email2]])
    unless taxman
      taxman = client.taxmen.build
      person = taxman.build_person
      contact = person.build_contact

      contact.emails.build(email: info[:email1])
      contact.emails.build(email: info[:email2])
    end

    client.save!
    client.taxmen << taxman

    Company.current_company.business_clients << client

    taxbill.taxman = taxman

    taxbill.save!
  end

private
  def find_document_and_save
    self.document = Document.find(self.document_id) unless self.document_id.blank?
  end
end