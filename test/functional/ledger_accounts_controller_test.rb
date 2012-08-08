require 'test_helper'

class LedgerAccountsControllerTest < ActionController::TestCase
  fixtures :ledger_accounts

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see show new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_ledger_account.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_ledger_account.id
    assert_response :success
  end

  private
  def current_ledger_account
    @document ||= ledger_accounts(:cash)
  end
end
