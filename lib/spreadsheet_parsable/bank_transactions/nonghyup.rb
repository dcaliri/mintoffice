# encoding: UTF-8

module SpreadsheetParsable
  module BankTransactions
    module Nonghyup
      extend ActiveSupport::Concern

      NONGHYUP = {
        :name => :nonghyup,
        :keys => {
          :transacted_at => :time,
          :in => :integer,
          :out => :integer,
          :remain => :integer,
        },
        :columns => {
          :transacted_at      => "거래일자",
          :out                => "출금금액",
          :in                 => "입금금액",
          :remain             => "거래후잔액",
          :transaction_type   => "거래내용",
          :note               => "거래기록사항",
          :branchname         => "거래점",
          :transacted_time    => "거래시간",
        },
        :position => {
          :start => {
            x: 2,
            y: 2
          },
          :end => 0
        }
      }

      module ClassMethods
        def nonghyup_bank_transaction_parser
          parser = ExcelParser.new
          parser.class_name BankTransaction
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