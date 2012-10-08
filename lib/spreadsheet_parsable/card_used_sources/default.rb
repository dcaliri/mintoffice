# encoding: UTF-8

module SpreadsheetParsable
  module CardUsedSources
    module Default
      extend ActiveSupport::Concern

      EXCEL_COLUMNS ||= {}
      EXCEL_COLUMNS[:default_card_used_sources] = {
        :card_no =>               "카드번호",
        :bank_account =>          "결제계좌번호",
        :bank_name =>             "결제은행명",
        :card_holder_name =>      "카드소유자명",
        :used_area =>             "사용구분",
        :approve_no =>            "승인번호",
        :approved_at =>           "승인일자",
        :approved_time =>         "승인시간",
        :sales_type =>            "매출종류코드",
        :money_krw =>             "승인금액(원화)",
        :money_foreign =>         "승인금액(외화)",
        :price =>                 "공급가액(원화)",
        :tax =>                   "부가세",
        :tip =>                   "봉사료",
        :monthly_duration =>      "할부기간",
        :exchange_krw =>          "외화거래일횐율",
        :foreign_country_code =>  "외화거래국가코드",
        :foreign_country_name =>  "외화거래국가명",
        :store_business_no =>     "가맹점사업자번호",
        :store_name =>            "가맹점명",
        :store_type =>            "가맹점업종명)",
        :store_zipcode =>         "가맹점우편번호",
        :store_addr1 =>           "가맹점주소1",
        :store_addr2 =>           "가맹점주소2",
        :store_tel =>              "가맹점전화번호"
      }

      EXCEL_KEYS ||= {}
      EXCEL_KEYS[:default_card_used_sources] = {
        :approve_no => :integer,
        :approved_at => :time,
      }

      EXCEL_OPTIONS ||= {}
      EXCEL_OPTIONS[:default_card_used_sources] = {
        :position => {
          :start => {
            x: 2,
            y: 1
          },
          :end => 0
        }
      }

      module ClassMethods
        # def used_sources_parser
        def default_card_used_sources_parser
          parser = ExcelParser.new
          parser.class_name ShinhanCardUsedHistory
          parser.column EXCEL_COLUMNS[:default_card_used_sources]
          parser.key EXCEL_KEYS[:default_card_used_sources]
          parser.option EXCEL_OPTIONS[:default_card_used_sources]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end