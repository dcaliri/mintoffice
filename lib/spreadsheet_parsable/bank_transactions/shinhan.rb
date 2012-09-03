# encoding: UTF-8

module SpreadsheetParsable
  module BankTransactions
    module Shinhan
      extend ActiveSupport::Concern

      SHINHAN = {
        :name => :shinhan,
        :keys => {
          :transacted_at => :time,
          :in => :integer,
          :out => :integer,
          :remain => :integer
        },
        :columns => {
          :transacted_at      => "거래일자",
          :transaction_type   => "적요",
          :in                 => "입금액",
          :out                => "출금액",
          :note               => "내용",
          :remain             => "잔액",
          :branchname         => "거래점명",
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
        def shinhan_bank_transaction_parser
          parser = ExcelParser.new
          parser.class_name BankTransaction
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