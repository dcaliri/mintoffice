class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  set_parser_columns :transfer_type, :transfered_at, :result, :out_bank_account, :in_bank_name, :in_bank_account, :money, :transfer_fee, :error_money, :registered_at, :error_code, :transfer_note, :incode, :out_account_note, :in_account_note, :in_person_name

  def self.open_and_parse_stylesheet(account, upload)
    @account = account
    super(upload)
  end

  def self.before_parser_filter(params)
    @account.number == params[:out_bank_account]
  end

  def self.make_unique_key(params)
    {transfer_type: params[:transfer_type], transfered_at: Time.zone.parse(params[:transfered_at])}
  end

  def related?(transaction)
    if transaction
      transaction.transacted_at == transfered_at && transaction.out == money
    else
      false
    end
  end
end