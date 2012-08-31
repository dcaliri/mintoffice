# encoding: UTF-8

module SpreadsheetParsable
  module BankTransactions
    module Ibk
      extend ActiveSupport::Concern

      IBK = {
        :name => :ibk,
        :keys => {
          :transacted_at => :time,
          :in => :integer,
          :out => :integer,
          :remain => :integer
        },
        :columns => {
          :transacted_at            => "거래일시",
          :out                      => "출금액",
          :in                       => "입금액",
          :remain                   => "잔액",
          :note                     => "거래내용",
          :out_bank_account         => "상대계좌번호",
          :out_bank_name            => "상대은행",
          :transaction_type         => "거래구분",
          :promissory_check_amount  => "수표어음금액",
          :cms_code                 => "CMS코드",
        },
        :position => {
          :start => {
            x: 8,
            y: 2
          },
          :end => -1
        }
      }


      module ClassMethods
        def ibk_bank_transaction_parser
          parser = ExcelParser.new
          parser.class_name BankTransaction
          parser.column IBK[:columns]
          parser.key IBK[:keys]
          parser.option :position => IBK[:position]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end