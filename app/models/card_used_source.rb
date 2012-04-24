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

  def self.latest
    order('approved_at DESC, approved_time DESC')
  end

  def self.total
    sum{|used| used.money_krw }
  end
end