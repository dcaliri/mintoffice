class BankAccountsController < ApplicationController
  expose(:bank_accounts) { BankAccount.all }
  expose(:bank_account)

  def show
    @attachments = Attachment.for_me(bank_account)
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def create
    bank_account.save!
    Attachment.save_for(bank_account, @user, params[:attachment])
    redirect_to :bank_accounts
  end

  def edit
    @attachments = Attachment.for_me(bank_account)
  end

  def update
    bank_account.save!
    Attachment.save_for(bank_account, @user, params[:attachment])
    redirect_to :bank_accounts
  end

  def destroy
    bank_account.destroy
    redirect_to :bank_accounts
  end
end