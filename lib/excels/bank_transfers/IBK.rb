module Excels
  module BankTransfers
    module IBK
      extend ActiveSupport::Concern


      IBK = {
        :name => :ibk,
        :keys => {
          :transfer_type => :integer,
          :transfered_at => :time,
        },
        :columns => [
          :transfer_type,
          :transfered_at,
          :transfered_at,
          :result,
          :out_bank_account,
          :money,
          :transfer_fee,
          :in_bank_name,
          :in_bank_account,
          :out_account_note,
          :in_account_note,
          :in_person_name,
          :cms_code,
          :currency_code
        ],
        :position => {
          :start => {
            x: 7,
            y: 2
          },
          :end => -1
        }
      }

      module ClassMethods
        def ibk_bank_transfer_parser
          parser = ExcelParser.new
          parser.class_name BankTransfer
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