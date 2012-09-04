# encoding: UTF-8
require 'test_helper'

class BusinessClientsControllerTest < ActionController::TestCase
  fixtures :business_clients

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

  test "should see show page" do
    get :show, :id => current_business_client.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_business_client.id
    assert_response :success
  end

  private
  def current_business_client
    @business_client ||= business_clients(:fixture)
  end
end
