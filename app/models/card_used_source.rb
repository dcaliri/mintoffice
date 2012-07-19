class CardUsedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  DEFAULT_COLUMNS = [:card_no,
                     :bank_account,
                     :bank_name,
                     :card_holder_name,
                     :used_area,
                     :approve_no,
                     :approved_at_strftime,
                     :approved_time_strftime,
                     :sales_type,
                     :money_krw,
                     :money_foreign,
                     :price,
                     :tax,
                     :tip,
                     :monthly_duration,
                     :exchange_krw,
                     :foreign_country_code,
                     :foreign_country_name,
                     :store_business_no,
                     :store_name,
                     :store_type,
                     :store_zipcode,
                     :store_addr1,
                     :store_addr2,
                     :store_tel
                     ]
                     
  validates_uniqueness_of :approve_no
  validates_presence_of :approve_no
  validates_presence_of :price
  validates_presence_of :tax
  validates_presence_of :tip
  validates_presence_of :store_addr1
  validates_presence_of :store_addr2

  def self.default_columns
    DEFAULT_COLUMNS
  end

  ###### DECORATOR ###############
  def approved_at_strftime
    approved_at.strftime("%Y %m.%d") rescue ""
  end

  def approved_time_strftime
    approved_time.strftime("%H:%M:%S") rescue ""
  end
  ################################

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.except_column :creditcard_id
    config.period_subtitle :approved_at
    config.krw [:money_krw, :exchange_krw, :price, :tax, :tip]
    config.align :right, [:money_foreign, :monthly_duration]
  end

  class << self
    def search(text)
      text = "%#{text}%"
      where('bank_name like ? OR card_holder_name like ? OR approve_no like ? OR money_krw like ? OR store_name like ?', text, text, text, text, text)
    end

    def group_by_name_anx_tax
      all.group_by{|cards| cards.bank_name }.map do |name, cards|
        {name: name, tax: cards.sum{|card| card.tax}}
      end
    end

    def latest
      order('approved_at DESC, approved_time DESC')
    end

    def oldest_at
      resource = order('approved_at DESC').last
      if resource && resource.approved_at
        resource.approved_at
      else
        Time.zone.now
      end
    end

    def total_tax
      sum{|used| used.tax }
    end

    def total_price
      sum{|used| used.money_krw ? used.money_krw : 0 }
    end
  end
end