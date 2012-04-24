class CardUsedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  include StylesheetParseable

  DEFAULT = {
    :name => :default,
    :keys => {
      :approved_at => :time,
      :approved_time => :time,
      :money_krw => :integer
    },
    :columns => [
      :card_no,
      :bank_account,
      :bank_name,
      :card_holder_name,
      :used_area,
      :approve_no,
      :approved_at,
      :approved_time,
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
    ],
    :position => {
      :start => {
        x: 2,
        y: 1
      },
      :end => 0
    }
  }

  set_parser_options DEFAULT

  class << self
    def open_and_parse_stylesheet(card, upload)
      @card = card
      super(upload)
    end

    def before_parser_filter(params)
      @card.cardno == params[:card_no]
    end

    def group_by_bank_name
      group("bank_name").select("card_used_sources.*, sum(tax) as tax")
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
  end
end