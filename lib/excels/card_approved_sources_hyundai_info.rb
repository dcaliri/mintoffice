# encoding: UTF-8

module Excels
  module CardApprovedSourcesHyundaiInfo
    extend ActiveSupport::Concern


    EXCEL_COLUMNS ||= {}
    EXCEL_COLUMNS[:card_approved_sources_hyundai] = {
      :used_at =>           "거래일자",
      :used_time =>         "시각",
      :card_no =>           "카드번호",
      :money =>             "승인금액",
      :money_us =>          "승인금액($)",
      :card_holder_name =>  "이용자명",
      :store_name =>        "가맹점명",
      :nation =>            "국가명",
      :status =>            "상태",
      :approve_no =>        "승인번호",
      :nation_statement =>  "국내외",
      :refuse_reason =>     "거절사유"
    }

    EXCEL_KEYS ||= {}
    EXCEL_KEYS[:card_approved_sources_hyundai] = {
      :approve_no => :integer
    }

    EXCEL_OPTIONS ||= {}
    EXCEL_OPTIONS[:card_approved_sources_hyundai] = {
      :position => {
        :start => {
          x: 2,
          y: 2
        },
        :end => -1
      }
    }

    module ClassMethods
      def approved_sources_hyundai_parser
        parser = ExcelParser.new
        parser.class_name CardApprovedSource
        parser.column EXCEL_COLUMNS[:card_approved_sources_hyundai]
        parser.key EXCEL_KEYS[:card_approved_sources_hyundai]
        parser.option EXCEL_OPTIONS[:card_approved_sources_hyundai]
        parser
      end
    end

    included do
      extend ClassMethods
    end
  end
end