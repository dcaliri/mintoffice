module Excels
  module CardUsedSourcesInfo
    EXCEL_COLUMNS ||= {}
    EXCEL_COLUMNS[:card_used_sources] = [
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

    EXCEL_KEYS ||= {}
    EXCEL_KEYS[:card_used_sources] = {
      :approved_at => :time,
      :approved_time => :time,
      :money_krw => :integer
    }

    EXCEL_OPTIONS ||= {}
    EXCEL_OPTIONS[:card_used_sources] = {
      :position => {
        :start => {
          x: 2,
          y: 1
        },
        :end => 0
      }
    }
  end
end