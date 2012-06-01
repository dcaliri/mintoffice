require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  test "should get index" do
    Company.create!(name: "minttech")
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
