# encoding: UTF-8

class CardApprovedSource < ActiveRecord::Base
  attr_accessor :used_time

  belongs_to :creditcard

  self.per_page = 20

  DEFAULT_COLUMNS = [:used_at_strftime,
                     :approve_no,
                     :card_holder_name,
                     :store_name,
                     :money,
                     :used_type,
                     :monthly_duration,
                     :card_type,
                     :canceled_at_strftime,
                     :status,
                     :will_be_paied_at_strftime,
                     :card_no,
                     :money_foreign,
                     :money_type,
                     :money_type_info,
                     :money_dollar,
                     :money_us,
                     :nation,
                     :nation_statement,
                     :refuse_reason
                     ]

  def self.default_columns
    DEFAULT_COLUMNS
  end


  ###### DECORATOR ###############
  def used_at_strftime
    used_at.strftime("%Y %m.%d") rescue ""
  end

  def canceled_at_strftime
    canceled_at.strftime("%Y %m.%d") rescue ""
  end

  def will_be_paied_at_strftime
    will_be_paied_at.strftime("%Y %m.%d") rescue ""
  end
  ################################

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.except_column :creditcard_id
    config.period_subtitle :used_at
    config.krw [:money]
  end

  class << self
    def filter_by_params(params)
      collections = latest.by_date(params[:will_be_paid_at]).search(params[:query])
      collections = collections.no_canceled if params[:no_canceled]
      collections
    end

    def by_date(date)
      if date == "all" or date.nil?
        where("")
      else
        date = Date.parse(date) if date.class == String && !date.blank?
        where(will_be_paied_at: date.to_time)
      end
    end

    def will_be_paid_at_list
      select(:will_be_paied_at).uniq.map{|source| source.will_be_paied_at.strftime("%Y-%m-%d") rescue ""}
    end

    def total_price
      sum{|used| used.money }
    end

    def search(text)
      text = "%#{text}%"
      where('approve_no like ? OR card_no like ? OR card_holder_name like ? OR store_name like ? OR money like ?', text, text, text, text, text)
    end

    def find_empty_cardbill
      if Cardbill.all.empty?
        where("")
      else
        where('approve_no not in (?)', Cardbill.all.map{|cardbill| cardbill.approveno})
      end.no_canceled
    end

    def no_canceled
     where('status NOT LIKE ?', I18n.t('models.card_approved_source.cancel'))
    end

    def generate_cardbill(owner)
      total_count = 0
      no_canceled.find_each do |approved_source|
        next if Cardbill.exists?(approveno: approved_source.approve_no)

        used_sources = CardUsedSource.where(approve_no: approved_source.approve_no)
        next if used_sources.empty?
        used_source = used_sources.first

        cardbill = approved_source.creditcard.cardbills.build(
          amount: used_source.price,
          servicecharge: used_source.tax.to_i,
          vat: used_source.tip.to_i,
          approveno: approved_source.approve_no,
          totalamount: approved_source.money,
          transdate: approved_source.used_at,
          storename: approved_source.store_name,
          storeaddr: "#{used_source.store_addr1} #{used_source.store_addr2}",
        )

        report = cardbill.build_report

        raise cardbill.errors.inspect if cardbill.invalid?

        cardbill.save!

        cardbill.report.reporters.destroy_all
        cardbill.report.accessors.destroy_all
        cardbill.report.permission owner, :write

        total_count += 1
      end
      total_count
    end
  end

  def cardbill
    collection = Cardbill.where(approveno: approve_no)
    collection.first unless collection.empty?
  end

  def used_at_to_s
    attribute = read_attribute(:used_at)
    attribute.blank? ? "" : attribute.strftime("%Y.%m.%d %H:%M")
  end

  def canceled_at_to_s
    attribute = read_attribute(:canceled_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  def will_be_paied_at_to_s
    attribute = read_attribute(:will_be_paied_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  def self.latest
    order("used_at DESC")
  end
end