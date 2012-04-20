class CardUsedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  include StylesheetParseable

  set_parser_columns [
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
  ]

  def self.latest
    order('approved_at DESC')
  end

  def self.make_unique_key(params)
    {approved_at: Time.zone.parse(params[:approved_at]), approved_time: Time.zone.parse(params[:approved_time]), money_krw: params[:money_krw]}
  end
end