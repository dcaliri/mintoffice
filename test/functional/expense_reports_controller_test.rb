require 'test_helper'

class ExpenseReportsControllerTest < ActionController::TestCase
  fixtures :cardbills, :expense_reports, :reports, :employees, :projects

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new, target_type: "Cardbill", target_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_expense_report.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_expense_report.id
    assert_response :success
  end

  private
  def current_cardbill
    @cardbill ||= cardbills(:has_permission_cardbill)
  end

  def current_expense_report
    @expense_report ||= expense_reports(:cardbill)
  end
end
