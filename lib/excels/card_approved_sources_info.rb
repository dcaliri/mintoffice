# encoding: UTF-8

module Excels
  module CardApprovedSourcesInfo
    extend ActiveSupport::Concern


    EXCEL_COLUMNS ||= {}
    EXCEL_COLUMNS[:card_approved_sources] = {
      :used_at =>           "이용일시",
      :approve_no =>        "승인번호",
      :card_no =>           "이용카드",
      :card_holder_name =>  "이용자명",
      :store_name =>        "가맹점명",
      :money =>             "이용금액",
      :used_type =>         "이용구분",
      :monthly_duration =>  "할부개월수",
      :card_type =>         "카드구분",
      :canceled_at =>       "취소일자",
      :status =>            "매입상태",
      :will_be_paied_at =>  "결제예정일"
    }

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

    module ClassMethods
      def approved_sources_parser
        parser = ExcelParser.new
        parser.class_name CardApprovedSource
        parser.column EXCEL_COLUMNS[:card_approved_sources]
        parser.key EXCEL_KEYS[:card_approved_sources]
        parser.option EXCEL_OPTIONS[:card_approved_sources]
        parser
      end
    end

    included do
      extend ClassMethods
    end
  end
end