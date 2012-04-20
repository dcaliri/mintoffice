class BankTransfersController < ApplicationController
  expose(:bank_account)
  expose(:bank_transfers) { bank_account.bank_transfers.latest.page(params[:page]) }
  expose(:bank_transfer)

  expose(:bank_transaction) { BankTransaction.find(params[:from]) if params[:from] }

  def upload
    bank_transfers.open_and_parse_stylesheet(bank_account, params[:upload])
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