# encoding: UTF-8

module SpreadsheetParsable
  module Taxbills
    module Purchase
      extend ActiveSupport::Concern

      PURCHASE = {
        :name => :purchase,
        :keys => {
          :approve_no => :integer
        },
        :columns => {
          :uid => "번호",
          :written_at => "작성일자",
          :approve_no => "승인번호",
          :transacted_at => "발급일자",
          :transmit_at => "전송일자",
          :seller_registration_number => "공급자사업자등록번호",
          :sellers_minor_place_registration_number => "종사업장번호",
          :sellers_company_name => "상호",
          :sellers_representative => "대표자명",
          :buyer_registration_number => "공급받는자사업자등록번호",
          :buyers_minor_place_registration_number => "종사업장번호",
          :buyers_company_name => "상호",
          :buyerss_representative => "대표자명",
          :total => "합계금액",
          :supplied_value => "공급가액",
          :tax => "세액",
          :taxbill_classification => "전자세금계산서분류",
          :taxbill_type => "전자세금계산서종류",
          :issue_type => "발급유형",
          :note => "비고",
          :etc => "기타",
          :bill_action_type => "영수/청구 구분",
          :seller_email => "공급자 이메일",
          :buyer1_email => "공급받는자 이메일1",
          :buyer2_email => "공급받는자 이메일2",
          :item_date => "품목일자",
          :item_name => "품목명",
          :item_standard => "품목규격",
          :quantity => "품목수량",
          :unitprice => "품목단가",
          :item_supply_price => "품목공급가액",
          :item_tax => "품목세액",
          :item_note => "품목비고",
        },
        :position => {
          :start => {
            x: 7,
            y: 1,
          },
          :end => 0
        }
      }
      module ClassMethods
        def purchase_taxbill_parser
          parser = ExcelParser.new
          parser.class_name Taxbill
          parser.column PURCHASE[:columns]
          parser.key PURCHASE[:keys]
          parser.option :position => PURCHASE[:position]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end