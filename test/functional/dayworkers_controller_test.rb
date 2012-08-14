require 'test_helper'

class DayworkersControllerTest < ActionController::TestCase
  fixtures :dayworkers, :contacts

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see find_contact page" do
    get :find_contact, :id => current_dayworker.id
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
