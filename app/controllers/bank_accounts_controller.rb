class BankAccountsController < ApplicationController
  expose(:bank_accounts) { BankAccount.all }
  expose(:bank_account)

  before_filter :only => [:show] { |c| c.save_attachment_id bank_account }

  def index
    @promissories = Promissory.scoped
  end

  def create
    bank_account.save!
    redirect_to bank_account
  end

  def update
    bank_account.save!
    redirect_to bank_account
  end

  def destroy
    bank_account.destroy
    redirect_to :bank_accounts
  end
end