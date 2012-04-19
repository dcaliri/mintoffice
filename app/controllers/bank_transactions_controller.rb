class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions }
  expose(:bank_transaction)

  def create
    bank_transactions.open_and_parse_stylesheet(params[:bank_transaction])
    redirect_to [bank_account, :bank_transactions]
  end
end