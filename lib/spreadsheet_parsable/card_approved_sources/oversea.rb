# encoding: UTF-8

module SpreadsheetParsable
  module CardApprovedSources
    module Oversea
      extend ActiveSupport::Concern

      EXCEL_COLUMNS ||= {}
      EXCEL_COLUMNS[:oversea_card_approved_sources] = {
        :used_at =>               "이용일시",
        :approved_number =>       "승인번호",
        :card_name =>             "이용카드",
        :card_holder_name =>      "이용자명",
        :store_name =>            "가맹점명",
        :money =>                 "이용금액",
        :money_locale =>          "현지금액",
        :money_locale_currency => "현지통화",
        :money_locale_name =>     "현지통화명",
        :money_us =>              "미화금액",
        :used_type =>             "이용구분",
        :card_type =>             "카드구분",
        :refused_at =>            "취소일자",
        :purchase_status =>       "매입상태",
        :will_be_paied_at =>      "결제예정일"
      }

      EXCEL_KEYS ||= {}
      EXCEL_KEYS[:oversea_card_approved_sources] = {
        :approved_number => :integer
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
          parser.class_name OverseaCardApprovedHistory
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