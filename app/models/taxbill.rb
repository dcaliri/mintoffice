# encoding: UTF-8

class Taxbill < ActiveRecord::Base
  belongs_to :taxman
  belongs_to :business_client
  has_many :items, :class_name => 'TaxbillItem', :dependent => :destroy

  BILL_TYPE = [:purchase, :sale]

  include Historiable
  include Attachmentable

  include SpreadsheetParsable

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

  PURCHASE = {
    :name => :purchase,
    :keys => {
      :transfered_at => :time,
    },
    :columns => {
      :uid => "번호",
      :written_at => "작성일자",
      :approve_no => "승인번호",
      :transacted_at => "발급일자",
      :transmit_at => "전송일자",
      :seller_registration_number => "공급자사업자등록번호",
      :sellers_minor_place_registration_number => "종사업장번호",
      :sellers_company_name => "상호",
      :sellers_representative => "대표자명",
      :buyer_registration_number => "공급받는자사업자등록번호",
      :buyers_minor_place_registration_number => "종사업장번호",
      :buyers_company_name => "상호",
      :buyerss_representative => "대표자명",
      :total => "합계금액",
      :supplied_value => "공급가액",
      :tax => "세액",
      :taxbill_classification => "전자세금계산서분류",
      :taxbill_type => "전자세금계산서종류",
      :issue_type => "발급유형",
      :note => "비고",
      :etc => "기타",
      :bill_action_type => "영수/청구",
      :section => "구분",
      :seller => "공급자",
      :seller_email => "이메일",
      :buyer1 => "공급받는자",
      :buyer1_email => "이메일1",
      :buyer2 => "공급받는자",
      :buyer2_email => "이메일2",
      :item_date => "품목일자",
      :item_name => "품목명",
      :item_standard => "품목규격",
      :quantity => "품목수량",
      :unitprice => "품목단가",
      :item_supply_price => "품목공급가액",
      :item_tax => "품목세액",
      :item_note => "품목비고",
    },
    :position => {
      :start => {
        x: 7,
        y: 1,
      },
      :end => 0
    }
  }

  def self.purchase_taxbill_parser
    parser = ExcelParser.new
    parser.class_name Taxbill
    parser.column PURCHASE[:columns]
    parser.key PURCHASE[:keys]
    parser.option :position => PURCHASE[:position]
    parser
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
      previews << Taxbill.build(params)
    end
    previews
  end
end