# encoding: UTF-8

class BankTransactionsController < ApplicationController
  expose(:bank_account) { BankAccount.access_list(current_person).find(params[:bank_account_id]) unless params[:bank_account_id].blank? }
  expose(:bank_transaction)
  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def index
    params[:bank_account_id] ||= (BankAccount.access_list(current_person).count == 0 ? nil : BankAccount.access_list(current_person).first.id)
    transactions = bank_account ? bank_account.bank_transactions : BankTransaction
    @bank_transactions = transactions.search(params[:query]).latest.page(params[:page])
  end

  def verify
    @bank_transactions = bank_account.bank_transactions.latest
  end

  def total
    @in = BankTransaction.in
    @out = BankTransaction.out
  end

  def preview
    bank_account = BankAccount.find(params[:bank_account])
    @bank_transactions = BankTransaction.preview_stylesheet(bank_account, bank_account.name_, params[:upload])
  rescue => error
    redirect_to [:excel, :bank_transactions], alert: error.message
  end

  def upload
    bank_account = BankAccount.find(params[:bank_account])
    BankTransaction.create_with_stylesheet(bank_account, bank_account.name_, params[:upload])
    redirect_to bank_transactions_path(bank_account_id: params[:bank_account])
  end

  def export
    transactions = bank_account ? bank_account.bank_transactions : BankTransaction
    include_column = current_employee.except_columns.default_columns_by_key('BankTransaction')

    send_file transactions.latest.export(params[:to].to_sym, include_column)
  end

  def create
    @bank_transaction = bank_account.bank_transactions.build(params[:bank_transaction])
    @bank_transaction.save!
    redirect_to @bank_transaction
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    render 'new'
  end

  def update
    bank_transaction.bank_account = bank_account
    bank_transaction.save!
    redirect_to bank_transaction
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    render 'edit'
  end

  def destroy
    bank_transaction.destroy
    redirect_to :bank_transactions
  end
end