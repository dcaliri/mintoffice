# encoding: UTF-8

require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should see main page" do
    get :index
    assert_response :success
  end

  test "admin should see admin bar" do
    get :index
    assert_response :success
    assert_select '.nav-collapse .nav .dropdown', 5
    assert_select '.nav-collapse .nav .dropdown .dropdown-toggle', '관리자 메뉴'
  end

  test "normal should not see normal bar" do
    switch_to_normal

    get :index
    assert_response :success
    assert_select '.nav-collapse .nav .dropdown', 4
  end
end