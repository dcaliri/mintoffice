# encoding: UTF-8
require 'test_helper'

class BankTransfersControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transfers

  setup do
    @valid_attributes = {
      bank_account_id: 1,
      transfer_type: "타행이체",
      transfered_at: "2012-04-16 10:57:18.000000",
      result: "거래완료",
      out_bank_account: "274-062855-01-012",
      in_bank_name: "신한은행",
      in_bank_account: "28505013648",
      money: 50000,
      transfer_fee: 500,
      error_money: 0,
      registered_at: "#{Time.zone.now}",
      error_code: nil,
      transfer_note: nil,
      incode: nil,
      out_account_note: "외부 내용",
      in_account_note: "내부 내용",
      in_person_name: "매니저",
      cms_code: nil,
      currency_code: "KRW"
    }
  end

  test "should see list page" do
    get :index
    assert_response :success
  end

  test "should see show page" do
    get :show, id: current_bank_transfer.id
    assert_response :success
  end

  test "should see new page" do
    get :new, id: current_bank_transfer.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, id: current_bank_transfer.id
    assert_response :success
  end

  # test "should preview bank transfer" do
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transfer_fixture.xlsx', 'application/vnd.ms-excel')
  #   post :preview, bank_type: 'nonghyup', upload: excel_file
  #   assert_response :success
  # end

  # test "should fail to preview bank transfer" do
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transfer_fixture.xlsx', 'application/vnd.ms-excel')
  #   post :preview, bank_type: 'shinhan', upload: excel_file
  #   assert_response :redirect

  #   get :excel
  #   assert_response :success

  #   assert_equal flash[:alert], "잘못된 형식의 엑셀파일입니다."
  # end

  test "should see excel page" do
    get :excel
    assert_response :success
  end

  test "should export bank transfer" do
    post :export, id: current_bank_transfer.id, to: :pdf
    assert_response :success
  end

  test "should create a new bank transfer" do
    post :create, bank_account_id: current_bank_account.id, bank_transfer: @valid_attributes
    assert_response :redirect
  end

  test "should update bank transfer" do
    post :update, id: current_bank_transfer.id, bank_transfer: @valid_attributes
    assert_response :redirect
  end

  test "should destroy bank transfer" do
    post :destroy, id: current_bank_transfer.id
    assert_response :redirect
  end

  private
  def current_bank_account
    @bank_account ||= bank_accounts(:shinhan_bank)
  end

  def current_bank_transfer
    @bank_transfer ||= bank_transfers(:shinhan)
  end
end