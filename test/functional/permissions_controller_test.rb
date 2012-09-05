require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase
  fixtures :permissions
  fixtures :people_permissions
  fixtures :groups_permissions

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  # test "should add account" do
  #   get :addaccount, id: current_permission.id, participant_type: :person, participant_name: add_account.name
  #   assert_response :success
  # end

  test "should see show page" do
    get :show, :id => current_permission.id
    assert_response :success
  end

  private
  def current_permission
    @permission ||= permissions(:commutes)
  end

  def add_account
    @participant ||= accounts(:normal_account)
  end
end
