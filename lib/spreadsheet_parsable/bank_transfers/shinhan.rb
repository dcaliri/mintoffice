# encoding: UTF-8

module SpreadsheetParsable
  module BankTransfers
    module Shinhan
      extend ActiveSupport::Concern

      SHINHAN = {
        :name => :shinhan,
        :keys => {
          :transfer_type => :integer,
          :transfered_at => :time,
        },
        :columns => {
          :transfer_type      => "이체구분",
          :transfered_at      => "거래일시",
          :result             => "처리결과",
          :out_bank_account   => "출금계좌",
          :in_bank_name       => "입금은행",
          :in_bank_account    => "입금계좌",
          :money              => "처리금액",
          :transfer_fee       => "수수료",
          :error_money        => "오류금액",
          :registered_at      => "등록일자",
          :error_code         => "오류코드",
          :transfer_note      => "거래메모",
          :incode             => "입금인코드",
          :out_account_note   => "출금통장표시내용",
          :in_account_note    => "입금통장표시내용",
          :in_person_name     => "입금인성명",
        },
        :position => {
          :start => {
            x: 2,
            y: 1
          },
          :end => 0
        }
      }

      module ClassMethods
        def shinhan_bank_transfer_parser
          parser = ExcelParser.new
          parser.class_name BankTransfer
          parser.column SHINHAN[:columns]
          parser.key SHINHAN[:keys]
          parser.option :position => SHINHAN[:position]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end