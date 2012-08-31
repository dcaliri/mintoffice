# encoding: UTF-8

module SpreadsheetParsable
  module CardUsedSources
    module Hyundai
      extend ActiveSupport::Concern

      EXCEL_COLUMNS ||= {}
      EXCEL_COLUMNS[:card_used_sources_hyundai] = {
        :used_at =>               "이용일자",
        :card_no =>               "카드번호",
        :card_holder_name =>      "이용자명",
        :store_name =>            "가맹점명",
        :tax_type =>              "과세유형",
        :price =>                 "이용금액",
        :approve_no =>            "승인번호",
        :sales_statement =>       "전표구분",
        :nation_statement =>      "국내외구분",
        :money_krw =>             "현지금액",
        :money_foreign =>         "미화금액",
        :exchange_krw =>          "미화환율",
        :prepayment_statement =>  "선납구분",
        :accepted_at =>           "접수일자",
        :approved_at =>           "결재일자",
        :apply_sales_statement => "전표신청",
        :purchase_statement =>    "구매여부"
      }

      EXCEL_KEYS ||= {}
      EXCEL_KEYS[:card_used_sources_hyundai] = {
        :approve_no => :integer,
        :approved_at => :time,
      }

      EXCEL_OPTIONS ||= {}
      EXCEL_OPTIONS[:card_used_sources_hyundai] = {
        :position => {
          :start => {
            x: 2,
            y: 1
          },
          :end => -1
        }
      }

      module ClassMethods
        def hyundai_used_sources_parser
          parser = ExcelParser.new
          parser.class_name CardUsedSource
          parser.column EXCEL_COLUMNS[:card_used_sources_hyundai]
          parser.key EXCEL_KEYS[:card_used_sources_hyundai]
          parser.option EXCEL_OPTIONS[:card_used_sources_hyundai]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end