require 'test_helper'

class PayrollCategoriesControllerTest < ActionController::TestCase
  fixtures :accounts, :employees, :payrolls, :payroll_categories

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_payroll_category.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_payroll_category.id
    assert_response :success
  end

  private
  def current_payroll_category
    @payroll_category ||= payroll_categories(:fixture)
  end
end
