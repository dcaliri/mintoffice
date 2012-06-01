require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  def setup
    User.create(id: 37, name: "admin", password: "1234")
    session[:user_id] = 37
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should show user" do
  #   get :show, :id => 37
  # end
  #
  # test "should get edit" do
  #   get :edit, :id => 37
  #   assert_response :success
  # end
end
