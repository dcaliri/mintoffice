class BankTransfersController < ApplicationController
  expose(:bank_account)
  expose(:bank_transfers) { bank_account.bank_transfers }
  expose(:bank_transfer)

  def upload
    bank_transfer.open_and_parse_stylesheet(params[:bank_transaction])
    redirect_to [bank_account, :bank_transfers]
  end

  def create
    bank_transfer.save!
    redirect_to [bank_account, :bank_transfers]
  end

  def update
    bank_transfer.save!
    redirect_to [bank_account, :bank_transfers]
  end

  def destroy
    bank_transfer.destroy
    redirect_to [bank_account, :bank_transfers]
  end
end