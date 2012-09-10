require 'test_helper'

class BankAccountsControllerTest < ActionController::TestCase
  fixtures :bank_accounts

  setup do
    @valid_attributes = {
      bank_account_id: 1,
      transacted_at: "2012-04-16 10:57:18.000000",
      transaction_type: "이자",
      in: 13993,
      out: 0,
      note: "2012년결산",
      remain: 165,
      branchname: nil,
      out_bank_account: nil,
      out_bank_name: "하나 은행",
      promissory_check_amount: nil,
      cms_code: nil,
      transact_order: 0
    }
  end

  test "should see list page" do
    get :index
    assert_response :success
  end

  test "should see bank account page" do
    get :show, id: current_bank_account.id
    assert_response :success
  end

  test "should see new bank account page" do
    get :new, id: current_bank_account.id
    assert_response :success
  end

  test "should create a new bank account" do
    post :create, bank_account: @valid_attributes
    assert_response :redirect
  end

  test "should see edit bank account page" do
    get :edit, id: current_bank_account.id
    assert_response :success
  end

  test "should update bank account" do
    post :update, id: current_bank_account, bank_account: @valid_attributes
    assert_response :redirect
  end

  test "should destroy bank account" do
    post :destroy, id: current_bank_account
    assert_response :redirect
  end

  test "should see total page" do
    get :total
    assert_response :success
  end

  private
  def current_bank_account
    @bank_account ||= bank_accounts(:shinhan_bank)
  end
end