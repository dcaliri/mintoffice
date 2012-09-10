# encoding: UTF-8
require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  fixtures :accounts

  setup do
    @valid_attributes = {
      name: "test",
      hashed_password: "96043f0adf13e8d440a0e90ec7a2b7757a16bc2c",
      salt: "21757029800.1164294613723833"
    }

    @invalid_attributes = {
      name: "",
      hashed_password: "96043f0adf13e8d440a0e90ec7a2b7757a16bc2c",
      salt: "21757029800.1164294613723833"
    }
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

  test "should create account" do
    post :create, :account => @valid_attributes
    assert_response :redirect

    assert_equal flash[:notice], I18n.t("common.messages.created", :model => Account.model_name.human)
  end

  test "should fail to create account" do
    post :create, :account => @invalid_attributes
    assert_response :success

    assert_equal flash[:notice], nil
  end

  test "should update account" do
    request.env["HTTP_REFERER"] = account_path(current_account.id)
    session[:return_to] = request.referer

    post :update, :id => current_account.id, :account => @valid_attributes
    assert_response :redirect

    assert_equal flash[:notice], I18n.t("common.messages.updated", :model => Account.model_name.human)
  end

  test "should fail to update account" do
    post :update, :id => current_account.id, :account => @invalid_attributes
    assert_response :success

    assert_equal flash[:notice], nil
  end

  test "should authenticate" do
    get :authenticate, name: 'admin', password: '1234'
    assert_response :redirect
  end

  test "should fail to authenticate" do
    get :authenticate, name: 'admin', password: '1'
    assert_response :success

    assert_equal flash[:notice], I18n.t("accounts.login.loginfail")
  end

  test "should fail to access login page" do
    get :login
    assert_response :redirect

    assert_equal flash[:notice], '로그인된 상태에서는 접근할 수 없는 페이지입니다.'
  end

  test "should logout this account" do
    get :logout
    assert_response :redirect
  end

  test "should disable account" do
    post :disable, id: normal_account.id
    assert_response :redirect
  end

  # test "should see changepw_form page" do
  #   # get :changepw_form
  #   get :changepw
  #   assert_response :success
  # end

  # test "should change password" do
  #   request.env["HTTP_REFERER"] = account_path(current_account.id)
  #   session[:return_to] = request.referer

  #   post :changepw, id: normal_account.id, password: '1234', password_confirmation: '1234'
  #   assert_response :redirect

  #   assert_equal flash[:notice], I18n.t("accounts.changepw.successfully_changed")
  # end

  # test "should not change password" do
  #   request.env["HTTP_REFERER"] = account_path(current_account.id)
  #   session[:return_to] = request.referer

  #   get :changepw, id: normal_account.id, password: '1234', password_confirmation: '1235'
  #   assert_response :redirect

  #   assert_equal flash[:notice], I18n.t("accounts.changepw.password_confirm_wrong")
  # end

  private
  def current_account
    @account ||= accounts(:admin_account)
  end

  def normal_account
    @normal ||= accounts(:normal_account)
  end

  def normal_person
    @normal_person ||= people(:normal)
  end
end
