require 'test_helper'

class DayworkersControllerTest < ActionController::TestCase
  fixtures :dayworkers, :contacts

  def setup
    current_user.hrinfo.permission.create!(name: 'documents')
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
    get :show, :id => current_dayworker.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_dayworker.id
    assert_response :success
  end

  private
  def current_dayworker
    @dayworker ||= dayworkers(:fixture)
  end
end
