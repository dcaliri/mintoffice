class BankAccountsController < ApplicationController
  expose(:bank_accounts) { BankAccount.all }
  expose(:bank_account)

  def create
    bank_account.save!
    redirect_to :bank_accounts
  end

  def update
    bank_account.save!
    redirect_to :bank_accounts
  end

  def destroy
    bank_account.destroy
    redirect_to :bank_accounts
  end
end