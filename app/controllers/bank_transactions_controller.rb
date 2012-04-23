class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions.latest.page(params[:page]) }
  expose(:bank_transaction)

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def upload
    if params[:previewed] == 'true'
      @account = BankAccount.find(session[:preview_bank_account])
      @account.destroy
      bank_transactions.create_with_stylesheet(params[:upload], params[:bank_type].to_sym)
      redirect_to [bank_account, :bank_transactions]
    else
      @account = BankAccount.create()
      @account.bank_transactions.preview_stylesheet(params[:upload], params[:bank_type].to_sym)
      session[:preview_bank_account] = @account.id
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