class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  set_parser_columns [:transacted_at, :transaction_type, :in, :out, :note, :remain, :branchname]
  def self.make_unique_key(params)
    {transacted_at: Time.zone.parse(params[:transacted_at]), in: params[:in], out: params[:out], remain: params[:remain]}
  end

  def related?(transfer)
    if transfer
      transacted_at == transfer.transfered_at && out == transfer.money
    else
      false
    end
  end
end