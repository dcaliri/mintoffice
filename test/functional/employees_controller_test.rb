require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  fixtures :employees, :attachments

  def setup
    current_account.employee.permission.create!(name: 'employees')
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see index page of retired member" do
    get :index, search_type: :retire
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_employee.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_employee.id
    assert_response :success
  end

  test "should see employment proof page" do
    get :new_employment_proof, :id => current_employee.id
    assert_response :success
  end

  private
  def current_employee
    @employee ||= employees(:fixture)
  end
end
