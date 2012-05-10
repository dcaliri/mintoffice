class BankTransfersController < ApplicationController
  before_filter :find_bank_account
  def find_bank_account
    @bank_account = BankAccount.find(params[:bank_account_id]) unless params[:bank_account_id].blank?
  end

  expose(:bank_transaction) { BankTransaction.find(params[:from]) if params[:from] }

  def index
    unless params[:bank_account_id].blank?
      transfers = BankAccount.find(params[:bank_account_id]).bank_transfers
    else
      transfers = BankTransfer
    end
    @bank_transfers = transfers.latest.page(params[:page])
  end

  def show
    @bank_transfer = BankTransfer.find(params[:id])
  end

  def total
    @in = BankTransfer.in
    @out = BankTransfer.out
  end

  def excel
    @bank_transfer = BankTransfer.new
  end

  def preview
    @bank_transfer = BankTransfer.new
    @bank_transfers = BankTransfer.preview_stylesheet(params[:bank_type], params[:upload])
  end

  def upload
    BankTransfer.create_with_stylesheet(params[:bank_type], params[:upload])
    redirect_to :bank_transfers
  end

  def new
    @bank_transfer = BankTransfer.new
  end

  def create
    @bank_transfer = @bank_account.bank_transfers.build(params[:bank_transfer])
    @bank_transfer.save!
    redirect_to @bank_transfer
  end

  def edit
    @bank_transfer = BankTransfer.find(params[:id])
  end

  def update
    @bank_transfer = BankTransfer.find(params[:id])
    @bank_transfer.bank_account = @bank_account
    @bank_transfer.save!
    redirect_to @bank_transfer
  end

  def destroy
    @bank_transfer = BankTransfer.find(params[:id])
    @bank_transfer.destroy
    redirect_to :bank_transfers
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

# class BankTransfersController < ApplicationController
#   expose(:bank_account)
#   expose(:bank_transfers) { bank_account.bank_transfers.latest.page(params[:page]) }
#   expose(:bank_transfer)
#
#   expose(:bank_transaction) { BankTransaction.find(params[:from]) if params[:from] }
#
#   def preview
#     @transfers = BankTransfer.preview_stylesheet(bank_account, params[:upload], params[:bank_type])
#   end
#
#   def upload
#     bank_transfers.create_with_stylesheet(bank_account, params[:upload], params[:bank_type])
#     redirect_to [bank_account, :bank_transfers]
#   end
#
#   def create
#     bank_transfer.save!
#     redirect_to [bank_account, :bank_transfers]
#   end
#
#   def update
#     bank_transfer.save!
#     redirect_to [bank_account, :bank_transfers]
#   end
#
#   def destroy
#     bank_transfer.destroy
#     redirect_to [bank_account, :bank_transfers]
#   end
# end