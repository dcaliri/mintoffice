class BankTransactionsController < ApplicationController
  expose(:bank_account)
  expose(:bank_transactions) { bank_account.bank_transactions.latest.page(params[:page]) }
  expose(:bank_transaction)

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def total
    @in = BankTransaction.in
    @out = BankTransaction.out
  end

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

  private
  def current_year
    params[:at] = Time.zone.now.year unless params[:at]
    Time.zone.parse("#{params[:at]}-01-01 00:00:00")
  end
  helper_method :current_year

  def oldest_year
    in_ = @in.oldest_at
    out_ = @out.oldest_at

    [in_, out_].min.year
  end
  helper_method :oldest_year
end