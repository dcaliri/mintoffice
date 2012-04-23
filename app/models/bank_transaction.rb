# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  BANK_LIST = [
    ["일반 은행", :default],
    ["기업 은행", :ibk]
  ]

  set_parser_columns [:transacted_at, :transaction_type, :in, :out, :note, :remain, :branchname], :default, position:{:start => [2, 1], :end => 0}
  set_parser_columns [:transacted_at, :in, :out, :remain, :note], :ibk, position:{:start => [8, 2], :end => -1}

  def self.make_unique_key(params)
    {transacted_at: Time.zone.parse(params[:transacted_at]), in: params[:in], out: params[:out], remain: params[:remain]}
  end

  def self.latest
    order("transacted_at DESC")
  end

  def transfer
    collection = BankTransfer.where("transfered_at = ? AND money + transfer_fee = ?", transacted_at, out)
    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end