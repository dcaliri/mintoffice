require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  fixtures :accounts

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

    assert_select '#google_account', 1
    assert_select '#redmine_account', 1
  end

  test "normal should not see google/redmine button" do
    switch_to_normal

    get :my, :id => normal_account.id
    assert_response :success

    assert_select '#google_account', 0
    assert_select '#redmine_account', 0
  end

  test "should see edit page" do
    get :edit, :id => current_account.id
    assert_response :success
  end

  test "should see changepw page" do
    get :changepw_form, :id => current_account.id
    assert_response :success
  end

  test "should see login page" do
    session[:person_id] = nil
    get :login
    assert_response :success
  end

  test "should see my page" do
    get :my
    assert_response :success
  end

  private
  def current_account
    @account ||= accounts(:admin_account)
  end

  def normal_account
    @normal ||= accounts(:normal_account)
  end
end
