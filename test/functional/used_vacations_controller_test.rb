require 'test_helper'

class UsedVacationsControllerTest < ActionController::TestCase
  fixtures :hrinfos, :vacations, :used_vacations

  def setup
    current_user.permission.create!(name: 'vacations')
  end

  test "should see new page" do
    get :new, user_id: 1, vacation_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, user_id: 1, vacation_id: 1, :id => current_used_vacation.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, user_id: 1, vacation_id: 1, :id => current_used_vacation.id
    assert_response :success
  end

  private
  def current_used_vacation
    @used_vacation ||= used_vacations(:fixture)
  end
end
