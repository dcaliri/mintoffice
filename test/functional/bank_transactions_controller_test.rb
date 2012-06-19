require 'test_helper'

class BankTransactionsControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transactions

  def setup
    current_user.permission.create!(name: 'bank_transactions')
  end

  test "should see list page" do
    get :index
    assert_response :success
  end

  test "should see bank transaction page" do
    get :show, id: current_bank_transaction.id
    assert_response :success
  end

  test "should see new bank transaction page" do
    get :new, id: current_bank_transaction.id
    assert_response :success
  end

  test "should see edit bank transaction page" do
    get :edit, id: current_bank_transaction.id
    assert_response :success
  end

  test "should see verify bank transaction page" do
    get :verify, bank_account_id: current_bank_account.id
    assert_response :success
  end

  test "should see excel of bank transaction page" do
    get :excel
    assert_response :success
  end

  test "should export bank transaction" do
    post :export, id: current_bank_transaction.id, to: :pdf
    assert_response :success
  end

  private
  def current_bank_account
    @bank_account ||= bank_accounts(:fixture)
  end

  def current_bank_transaction
    @bank_transaction ||= bank_transactions(:fixture)
  end
end