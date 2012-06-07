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
        :columns => [
          :transacted_at,
          :out,
          :in,
          :remain,
          :note,
          :out_bank_account,
          :out_bank_name,
          :transaction_type,
          :promissory_check_amount,
          :cms_code
        ],
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