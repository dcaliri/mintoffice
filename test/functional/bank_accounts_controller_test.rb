require 'test_helper'

class BankAccountsControllerTest < ActionController::TestCase
  fixtures :bank_accounts

  def setup
    current_user.hrinfo.permission.create!(name: 'bank_accounts')
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

  test "should see edit bank account page" do
    get :edit, id: current_bank_account.id
    assert_response :success
  end

  test "should see total page" do
    get :total
    assert_response :success
  end


  private
  def current_bank_account
    @bank_account ||= bank_accounts(:fixture)
  end
end