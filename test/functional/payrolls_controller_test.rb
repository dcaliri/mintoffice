require 'test_helper'

class PayrollsControllerTest < ActionController::TestCase
  fixtures :users, :hrinfos, :payrolls, :payroll_items

  def setup
    current_user.permission.create!(name: 'documents')
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
    get :show, :id => current_payroll.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_payroll.id
    assert_response :success
  end

  private
  def current_payroll
    @payroll ||= payrolls(:fixture)
  end
end
