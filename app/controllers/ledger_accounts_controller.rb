class LedgerAccountsController < ApplicationController
  expose(:ledger_account)

  def index
    @accounts = LedgerAccount.where("")
  end

  def create
    ledger_account.save!
    redirect_to ledger_account
  end

  def update
    ledger_account.save!
    redirect_to ledger_account
  end

  def destroy
    ledger_account.destroy
    redirect_to :ledger_accounts
  end
end