require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  fixtures :accounts

  def setup
    current_account.employee.permission.create!(name: 'accounts')
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_account.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_account.id
    assert_response :success
  end

  test "should see changepw page" do
    get :changepw, :account_id => current_account.id
    assert_response :success
  end

  test "should see login page" do
    get :login
    assert_response :success
  end

  test "should see my page" do
    get :my
    assert_response :success
  end
end
