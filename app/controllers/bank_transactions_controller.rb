class BankTransactionsController < ApplicationController
  before_filter :find_bank_account
  def find_bank_account
    @bank_account = BankAccount.find(params[:bank_account_id]) unless params[:bank_account_id].blank?
  end

  expose(:bank_transfer) { BankTransfer.find(params[:from]) if params[:from] }

  def index
    unless params[:bank_account_id].blank?
      transactions = BankAccount.find(params[:bank_account_id]).bank_transactions
    else
      transactions = BankTransaction
    end
    @bank_transactions = transactions.latest.page(params[:page])
  end

  def show
    @bank_transaction = BankTransaction.find(params[:id])
  end

  def total
    @in = BankTransaction.in
    @out = BankTransaction.out
  end

  def excel
    @bank_transaction = BankTransaction.new
  end

  def preview
    @bank_transaction = BankTransaction.new
    @transactions = BankTransaction.preview_stylesheet(params[:upload], params[:bank_type])
  end

  def upload
    BankTransaction.create_with_stylesheet(params[:upload], params[:bank_type])
    redirect_to :bank_transactions
  end

  def new
    @bank_transaction = BankTransaction.new
  end

  def create
    @bank_transaction = @bank_account.bank_transactions.build(params[:bank_transaction])
    @bank_transaction.save!
    redirect_to @bank_transaction
  end

  def edit
    @bank_transaction = BankTransaction.find(params[:id])
  end

  def update
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.bank_account = @bank_account
    @bank_transaction.save!
    redirect_to @bank_transaction
  end

  def destroy
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.destroy
    redirect_to :bank_transactions
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