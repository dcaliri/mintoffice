require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase
  fixtures :permissions

  def setup
    current_user.permission.create!(name: 'documents')
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
    get :show, :id => current_permission.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_permission.id
    assert_response :success
  end

  private
  def current_permission
    @permission ||= permissions(:fixture)
  end
end
