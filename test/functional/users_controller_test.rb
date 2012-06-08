require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    current_user.permission.create!(name: 'users')
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
    get :show, :id => current_user.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_user.id
    assert_response :success
  end

  test "should see changepw page" do
    get :changepw, :user_id => current_user.id
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
