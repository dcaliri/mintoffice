require 'test_helper'

class BankTransfersControllerTest < ActionController::TestCase
  def setup
    current_user.permission.create!(name: 'bank_transfers')
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

  test "should see excel of bank transaction page" do
    get :excel
    assert_response :success
  end

  private
  def current_bank_account
    @bank_account ||= BankAccount.create!
  end

  def current_bank_transaction
    @bank_transfer ||= current_bank_account.bank_transfers.create!
  end
end