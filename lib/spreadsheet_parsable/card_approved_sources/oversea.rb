# encoding: UTF-8

module SpreadsheetParsable
  module CardApprovedSources
    module Oversea
      extend ActiveSupport::Concern

      EXCEL_COLUMNS ||= {}
      EXCEL_COLUMNS[:oversea_card_approved_sources] = {
        :used_at =>             "이용일시",
        :approve_no =>          "승인번호",
        :card_no =>             "이용카드",
        :card_holder_name =>    "이용자명",
        :store_name =>          "가맹점명",
        :money =>               "이용금액",
        :money_foreign =>       "현지금액",
        :money_type =>          "현지통화",
        :money_type_info =>     "현지통화명",
        :money_dollar =>        "미화금액",
        :used_type =>           "이용구분",
        :card_type =>           "카드구분",
        :canceled_at =>         "취소일자",
        :status =>              "매입상태",
        :will_be_paied_at =>     "결제예정일"
      }

      EXCEL_KEYS ||= {}
      EXCEL_KEYS[:oversea_card_approved_sources] = {
        :approve_no => :integer
      }

      EXCEL_OPTIONS ||= {}
      EXCEL_OPTIONS[:oversea_card_approved_sources] = {
        :position => {
          :start => {
            x: 2,
            y: 1
          },
          :end => 0
        }
      }

      module ClassMethods
        # def approved_sources_oversea_parser
        def oversea_card_approved_sources_parser
          parser = ExcelParser.new
          parser.class_name CardApprovedSource
          parser.column EXCEL_COLUMNS[:oversea_card_approved_sources]
          parser.key EXCEL_KEYS[:oversea_card_approved_sources]
          parser.option EXCEL_OPTIONS[:oversea_card_approved_sources]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end