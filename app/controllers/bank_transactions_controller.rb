class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions.latest.page(params[:page]) }
  expose(:bank_transaction)

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def upload
    if params[:previewed] == 'true'
      bank_transactions.create_with_stylesheet(params[:upload], params[:bank_type].to_sym)
      redirect_to [bank_account, :bank_transactions]
    else
      @transactions = BankTransaction.preview_stylesheet(params[:upload], params[:bank_type].to_sym)
      params[:previewed] = true
      render 'excel'
    end
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