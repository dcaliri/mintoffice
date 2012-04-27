class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions.latest.page(params[:page]) }
  expose(:bank_transaction)

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def preview
    @transactions = BankTransaction.preview_stylesheet(params[:upload], params[:bank_type])
  end

  def upload
    bank_transactions.create_with_stylesheet(params[:upload], params[:bank_type])
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