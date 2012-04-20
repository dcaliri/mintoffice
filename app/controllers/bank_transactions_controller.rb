class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions.latest.page(params[:page]) }
  expose(:bank_transaction)

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def upload
    bank_transactions.open_and_parse_stylesheet(params[:bank_transaction])
    redirect_to [bank_account, :bank_transactions]
  end

  def create
    bank_transaction.save!
    redirect_to [bank_account, :bank_transactions]
  end

  def update
    bank_transaction.save!
    redirect_to [bank_account, :bank_transactions]
  end

  def destroy
    bank_transaction.destroy
    redirect_to [bank_account, :bank_transactions]
  end
end