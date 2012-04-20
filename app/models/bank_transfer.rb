class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  set_parser_columns :transfer_type, :transfered_at, :result, :out_bank_account, :in_bank_name, :in_bank_account, :money, :transfer_fee, :error_money, :registered_at, :error_code, :transfer_note, :incode, :out_account_note, :in_account_note, :in_person_name
  def self.make_unique_key(params)
    {transfer_type: params[:transfer_type], transfered_at: Time.zone.parse(params[:transfered_at])}
  end
end