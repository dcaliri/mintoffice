# encoding: UTF-8

class BankTransactionsController < ApplicationController
  expose(:bank_account) { BankAccount.find(params[:bank_account_id]) unless params[:bank_account_id].blank? }
  expose(:bank_transaction)
  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def index
    transactions = bank_account ? bank_account.bank_transactions : BankTransaction
    @bank_transactions = transactions.latest.page(params[:page])
  end

  def verify
    @bank_transactions = bank_account ? bank_account.bank_transactions : BankTransaction
    @bank_transactions = @bank_transactions.latest
#    @latest_transaction = @bank_transactions.first
    render :stream => true
  end

  def total
    @in = BankTransaction.in
    @out = BankTransaction.out
  end

  def preview
    bank_account = BankAccount.find(params[:bank_account])
    @transactions = BankTransaction.preview_stylesheet(bank_account, params[:bank_type], params[:upload])
  end

  def upload
    bank_account = BankAccount.find(params[:bank_account])
    BankTransaction.create_with_stylesheet(bank_account, params[:bank_type], params[:upload])
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