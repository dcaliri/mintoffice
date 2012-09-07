require 'test_helper'

class BankTransfersControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transfers

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
  #   excel_file = fixture_file_upload('excels/nonghyup_bank_transfer_fixture.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  #   post :preview, bank_type: 'nonghyup', upload: excel_file
  #   assert_response :success
  # end

  test "should fail to preview bank transfer" do
    excel_file = fixture_file_upload('excels/nonghyup_bank_transfer_fixture.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    post :preview, bank_type: 'shinhan', upload: excel_file
    assert_response :redirect
  end

  test "should see excel page" do
    get :excel
    assert_response :success
  end

  test "should export bank transfer" do
    post :export, id: current_bank_transfer.id, to: :pdf
    assert_response :success
  end

  private
  def current_bank_account
    @bank_account ||= bank_accounts(:shinhan_bank)
  end

  def current_bank_transfer
    @bank_transfer ||= bank_transfers(:shinhan)
  end
end