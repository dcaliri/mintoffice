require 'test_helper'

class VacationsControllerTest < ActionController::TestCase
  fixtures :hrinfos, :vacations

  def setup
    current_user.hrinfo.permission.create!(name: 'vacations')
  end

  test "should see index page" do
    get :index, user_id: 1
    assert_response :success
  end

  test "should see new page" do
    get :new, user_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, user_id: 1, :id => current_vacation.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, user_id: 1, :id => current_vacation.id
    assert_response :success
  end

  private
  def current_vacation
    @vacation ||= vacations(:fixture)
  end
end
