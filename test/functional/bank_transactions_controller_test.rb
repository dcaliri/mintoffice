# encoding: UTF-8
require 'test_helper'

class BankTransactionsControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transactions

  setup do
    @valid_attributes = {
      bank_account_id: 1,
      transacted_at: "2012-04-16 10:57:18.000000",
      transaction_type: "이자",
      in: 0,
      out: 0,
      note: "2012년결산",
      remain: 505,
      branchname: nil,
      out_bank_account: nil,
      out_bank_name: "하나 은행",
      promissory_check_amount: nil,
      cms_code: nil,
      transact_order: 0
    }

    @invalid_attributes = {
      bank_account_id: 1,
      transacted_at: "2012-04-16 10:57:18.000000",
      transaction_type: "이자",
      in: 0,
      out: 0,
      note: "2012년결산",
      remain: 105,
      branchname: nil,
      out_bank_account: nil,
      out_bank_name: "하나 은행",
      promissory_check_amount: nil,
      cms_code: nil,
      transact_order: 0
    }

    @update_attributes = {
      bank_account_id: 1,
      transacted_at: "2012-04-16 10:57:18.000000",
      transaction_type: "수정된 이자",
      in: 13993,
      out: 0,
      note: "결산",
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

  # test "should see preview page" do
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transaction_fixture.xls', 'application/vnd.ms-excel')
  #   post :preview, bank_account: nonghyup_bank_account, upload: excel_file
  #   assert_response :success
  # end

  # test "should fail to see preview page" do
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transaction_fixture.xls', 'application/vnd.ms-excel')
  #   post :preview, bank_account: current_bank_account, upload: excel_file
  #   assert_response :redirect

  #   get :excel
  #   assert_response :success

  #   assert_equal flash[:alert], "잘못된 형식의 엑셀파일입니다."
  # end

  test "should see excel of bank transaction page" do
    get :excel
    assert_response :success
  end

  test "should export bank transaction" do
    post :export, id: current_bank_transaction.id, to: :pdf
    assert_response :success
  end

  test "should create a new bank transaction" do
    post :create, bank_account_id: current_bank_account.id, bank_transaction: @valid_attributes
    assert_response :redirect
  end

  test "should not create a new bank transaction with invalid data" do
    post :create, bank_account_id: current_bank_account.id, bank_transaction: @invalid_attributes
    assert_response :success
  end

  test "should update bank transaction" do
    post :update, bank_account_id: current_bank_account.id, id: current_bank_transaction.id, bank_transaction: @update_attributes
    assert_response :redirect
  end

  test "should destroy bank transaction" do
    post :destroy, id: current_bank_transaction.id
    assert_response :redirect
  end

  private
  def current_bank_account
    @current_bank_account ||= bank_accounts(:shinhan_bank)
  end

  def nonghyup_bank_account
    @nonghyup_bank_account ||= bank_accounts(:nonghyup_bank)
  end

  def current_bank_transaction
    @current_bank_transaction ||= bank_transactions(:hana)
  end
end