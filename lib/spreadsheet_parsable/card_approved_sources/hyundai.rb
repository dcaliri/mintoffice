# encoding: UTF-8

module SpreadsheetParsable
  module CardApprovedSources
    module Hyundai
      extend ActiveSupport::Concern

      EXCEL_COLUMNS ||= {}
      EXCEL_COLUMNS[:hyundai_card_approved_sources] = {
        :transacted_date =>   "거래일자",
        :transacted_time =>   "시각",
        :card_number =>       "카드번호",
        :money =>             "승인금액",
        :money_us =>          "승인금액($)",
        :card_holder_name =>  "이용자명",
        :store_name =>        "가맹점명",
        :nation =>            "국가명",
        :status =>            "상태",
        :approve_number =>    "승인번호",
        :nation_statement =>  "국내외",
        :refuse_reason =>     "거절사유"
      }

      EXCEL_KEYS ||= {}
      EXCEL_KEYS[:hyundai_card_approved_sources] = {
        :approve_number => :integer
      }

      EXCEL_OPTIONS ||= {}
      EXCEL_OPTIONS[:hyundai_card_approved_sources] = {
        :position => {
          :start => {
            x: 2,
            y: 2
          },
          :end => -1
        }
      }

      module ClassMethods
        # def approved_sources_hyundai_parser
        def hyundai_card_approved_sources_parser
          parser = ExcelParser.new
          parser.class_name HyundaiCardApprovedHistory
          parser.column EXCEL_COLUMNS[:hyundai_card_approved_sources]
          parser.key EXCEL_KEYS[:hyundai_card_approved_sources]
          parser.option EXCEL_OPTIONS[:hyundai_card_approved_sources]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end