class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions }
  expose(:bank_transaction)

  def excel
  end

  def upload
    bank_transactions.open_and_parse_stylesheet(params[:upload])
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