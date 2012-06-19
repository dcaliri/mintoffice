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
    @bank_account ||= bank_accounts(:fixture)
  end

  def current_bank_transfer
    @bank_transfer ||= bank_transfers(:fixture)
  end
end