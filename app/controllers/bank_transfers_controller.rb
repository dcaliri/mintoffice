class BankTransfersController < ApplicationController
  expose(:bank_account) { BankAccount.find(params[:bank_account_id]) unless params[:bank_account_id].blank? }
  expose(:bank_transfer)
  expose(:bank_transaction) { BankTransaction.find(params[:from]) if params[:from] }

  def index
    transfers = bank_account ? bank_account.bank_transfers : BankTransfer
    @bank_transfers = transfers.latest.page(params[:page])
  end

  def total
    @in = BankTransfer.in
    @out = BankTransfer.out
  end

  def preview
    @bank_transfers = BankTransfer.preview_stylesheet(params[:bank_type], params[:upload])
  rescue => error
    redirect_to [:excel, :bank_transfers], alert: error.message
  end

  def upload
    BankTransfer.create_with_stylesheet(params[:bank_type], params[:upload])
    redirect_to :bank_transfers
  end

  def export
    transfers = bank_account ? bank_account.bank_transfers : BankTransfer
    send_file transfers.latest.export(params[:to].to_sym, except_column(:bank_transfer))
  end

  def create
    bank_transfer = bank_account.bank_transfers.build(params[:bank_transfer])
    bank_transfer.save!
    redirect_to bank_transfer
  end

  def update
    bank_transfer.bank_account = bank_account
    bank_transfer.save!
    redirect_to bank_transfer
  end

  def destroy
    bank_transfer.destroy
    redirect_to :bank_transfers
  end
end