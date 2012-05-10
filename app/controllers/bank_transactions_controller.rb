class BankTransactionsController < ApplicationController
  expose(:bank_account) { BankAccount.find(params[:bank_account_id]) unless params[:bank_account_id].blank? }
  expose(:bank_transaction)
  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def index
    transactions = bank_account ? bank_account.bank_transactions : BankTransaction
    @bank_transactions = transactions.latest.page(params[:page])
  end

  def total
    @in = BankTransaction.in
    @out = BankTransaction.out
  end

  def preview
    @transactions = BankTransaction.preview_stylesheet(params[:upload], params[:bank_type])
  end

  def upload
    BankTransaction.create_with_stylesheet(params[:upload], params[:bank_type])
    redirect_to :bank_transactions
  end

  def create
    bank_transaction = bank_account.bank_transactions.build(params[:bank_transaction])
    bank_transaction.save!
    redirect_to bank_transaction
  end

  def update
    bank_transaction.bank_account = bank_account
    bank_transaction.save!
    redirect_to bank_transaction
  end

  def destroy
    bank_transaction.destroy
    redirect_to :bank_transactions
  end
end