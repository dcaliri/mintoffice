class BankTransactionsController < ApplicationController
  expose(:bank_transactions) { BankTransaction.all }
  expose(:bank_transaction)

  def create
    BankTransaction.open_and_parse_stylesheet(params[:bank_transaction])
    redirect_to :bank_transactions
  end
end