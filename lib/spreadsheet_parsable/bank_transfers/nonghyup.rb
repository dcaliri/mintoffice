# encoding: UTF-8

module SpreadsheetParsable
  module BankTransfers
    module Nonghyup
      extend ActiveSupport::Concern

      NONGHYUP = {
        :name => :nonghyup,
        :keys => {
          :transfered_at => :time,
        },
        :columns => {
          :out_bank_account   => "출금계좌번호",
          :in_bank_name       => "입금은행",
          :in_bank_account    => "입금계좌번호",
          :in_person_name     => "예금주",
          :transfered_at      => "이체일자",
          :money              => "이체금액",
          :transfer_fee       => "수수료",
          :result             => "처리결과",
        },
        :position => {
          :start => {
            x: 11,
            y: 1,
          },
          :end => -1
        }
      }

      module ClassMethods
        def nonghyup_bank_transfer_parser
          parser = ExcelParser.new
          parser.class_name BankTransfer
          parser.column NONGHYUP[:columns]
          parser.key NONGHYUP[:keys]
          parser.option :position => NONGHYUP[:position]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end