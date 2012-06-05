require 'test_helper'

class BankTransfersControllerTest < ActionController::TestCase
  fixtures :bank_accounts
  fixtures :bank_transfers

  def setup
    current_user.permission.create!(name: 'bank_transfers')
  end

  test "should see list page" do
    get :index
    assert_response :success
  end

  test "should see bank transaction page" do
    get :show, id: current_bank_transfer.id
    assert_response :success
  end

  test "should see new bank transaction page" do
    get :new, id: current_bank_transfer.id
    assert_response :success
  end

  test "should see edit bank transaction page" do
    get :edit, id: current_bank_transfer.id
    assert_response :success
  end

  test "should see excel of bank transaction page" do
    get :excel
    assert_response :success
  end

  private
  def current_bank_account
    @bank_account ||= bank_accounts(:fixture)
  end

  def current_bank_transfer
    @bank_transfer ||= bank_transfers(:fixture)
  end
end