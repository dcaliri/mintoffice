class BankAccountsController < ApplicationController
  expose(:bank_accounts) { BankAccount.scoped.access_list(current_person) }
  expose(:bank_account)

  before_filter :only => [:show] { |c| c.save_attachment_id bank_account }

  def index
    @promissories = Promissory.scoped.access_list(current_person)
    @investments = Investment.scoped.access_list(current_person)
    @total_amount = bank_accounts.remain + @promissories.total_amount + @investments.total_amount
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