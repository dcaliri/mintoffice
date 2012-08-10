require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  fixtures :groups

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_group.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_group.id
    assert_response :success
  end

  private
  def current_group
    @group ||= groups(:admin)
  end
end
