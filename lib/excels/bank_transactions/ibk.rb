module Excels
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
        # 데이터 검증을 하지 않기 대문에 필드명이 필요없다.
        :columns => {
          :transacted_at            => "",
          :out                      => "",
          :in                       => "",
          :remain                   => "",
          :note                     => "",
          :out_bank_account         => "",
          :out_bank_name            => "",
          :transaction_type         => "",
          :promissory_check_amount  => "",
          :cms_code                 => "",
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
          parser.option :position => IBK[:position], :validate => false
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end