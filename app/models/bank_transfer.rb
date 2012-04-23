# encoding: UTF-8

class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account

  self.per_page = 20

  include StylesheetParseable

  BANK_LIST = [
    ["일반 은행", :default],
    ["기업 은행", :ibk]
  ]

  set_parser_columns [:transfer_type, :transfered_at, :result, :out_bank_account, :in_bank_name, :in_bank_account, :money, :transfer_fee, :error_money, :registered_at, :error_code, :transfer_note, :incode, :out_account_note, :in_account_note, :in_person_name], :default, position:{:start => [2, 1], :end => 0}
  set_parser_columns [:transfer_type, :transfered_at, :transfered_at, :result, :out_bank_account, :money, :transfer_fee, :in_bank_name, :in_bank_account, :out_account_note, :in_account_note, :in_person_name], :ibk, position: {:start => [7, 2], :end => -1}
  def self.open_and_parse_stylesheet(account, upload, type)
    @account = account
    super(upload, type)
  end

  def self.before_parser_filter(params)
    @account.number == params[:out_bank_account]
  end

  def self.make_unique_key(params)
    {transfer_type: params[:transfer_type], transfered_at: Time.zone.parse(params[:transfered_at])}
  end

  def self.latest
    order("transfered_at DESC")
  end

  def transaction
    collection = BankTransaction.where(transacted_at: transfered_at, out: money + transfer_fee)
    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end