# encoding: UTF-8
require 'test_helper'

class BusinessClientsControllerTest < ActionController::TestCase
  fixtures :business_clients

  setup do
    @valid_attributes = {
      name: "test",
      registration_number: "123-321-1234",
      category: "test",
      business_status: "test",
      address: "MAC OS",
      owner: "MINT",
      company_id: 1
    }

    @invalid_attributes = {
      name: nil,
      registration_number: "123-321-1234",
      category: "test",
      business_status: "test",
      address: "MAC OS",
      owner: "MINT",
      company_id: 1
    }
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should'n see index page with another company" do
    get :index
    assert_response :success
    
    assert_select '#list-table tr td', '테스트 거래처'
    assert_select '#list-table tr td', '김 개똥 거래처'
    assert_select '#list-table tr td', {count: 0, text: "다른 회사 거래처"}
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should create a new business client" do
    post :create, business_client: @valid_attributes
    assert_response :redirect

    get :show, :id => current_business_client.id
    assert_response :success

    assert_equal flash[:notice], I18n.t("common.messages.created", :model => BusinessClient.model_name.human)
  end

  test "should fail to create a new business client" do
    post :create, business_client: @invalid_attributes
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_business_client.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_business_client.id
    assert_response :success
  end

  test "should update business client" do
    post :update, :id => current_business_client.id, business_client: @valid_attributes
    assert_response :redirect

    get :edit, :id => current_business_client.id
    assert_response :success

    assert_equal flash[:notice], I18n.t("common.messages.updated", :model => BusinessClient.model_name.human)
  end

  test "should fail to update business client" do
    post :update, :id => current_business_client.id, business_client: @invalid_attributes
    assert_response :success
  end

  private
  def current_business_client
    @business_client ||= business_clients(:fixture)
  end
end
