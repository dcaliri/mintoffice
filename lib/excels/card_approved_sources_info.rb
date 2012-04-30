module Excels
  module CardApprovedSourcesInfo
    EXCEL_COLUMNS ||= {}
    EXCEL_COLUMNS[:card_approved_sources] = [
      :used_at,
      :approve_no,
      :card_no,
      :card_holder_name,
      :store_name,
      :money,
      :used_type,
      :monthly_duration,
      :card_type,
      :canceled_at,
      :status,
      :will_be_paied_at
    ]

    EXCEL_KEYS ||= {}
    EXCEL_KEYS[:card_approved_sources] = {
      :approve_no => :integer
    }

    EXCEL_OPTIONS ||= {}
    EXCEL_OPTIONS[:card_approved_sources] = {
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