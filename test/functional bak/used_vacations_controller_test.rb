require 'test_helper'

class UsedVacationsControllerTest < ActionController::TestCase
  fixtures :employees, :vacations, :used_vacations

  test "should see new page" do
    get :new, account_id: 1, vacation_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, account_id: 1, vacation_id: 1, :id => current_used_vacation.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, account_id: 1, vacation_id: 1, :id => current_used_vacation.id
    assert_response :success
  end

  private
  def current_used_vacation
    @used_vacation ||= used_vacations(:fixture)
  end
end
