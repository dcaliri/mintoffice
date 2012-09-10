# encoding: UTF-8
require 'test_helper'

class BankTransactionsControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transactions

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
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transaction_fixture.xls', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  #   post :preview, bank_account: nonghyup_bank_account, upload: excel_file
  #   assert_response :success
  # end

  # test "should fail to see preview page" do
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transaction_fixture.xls', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
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