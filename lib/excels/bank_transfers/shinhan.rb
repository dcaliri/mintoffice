module Excels
  module BankTransfers
    module Shinhan
      extend ActiveSupport::Concern

      SHINHAN = {
        :name => :shinhan,
        :keys => {
          :transfer_type => :integer,
          :transfered_at => :time,
        },
        :columns => [
          :transfer_type,
          :transfered_at,
          :result,
          :out_bank_account,
          :in_bank_name,
          :in_bank_account,
          :money,
          :transfer_fee,
          :error_money,
          :registered_at,
          :error_code,
          :transfer_note,
          :incode,
          :out_account_note,
          :in_account_note,
          :in_person_name
        ],
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