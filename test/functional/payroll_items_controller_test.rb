require 'test_helper'

class PayrollItemsControllerTest < ActionController::TestCase
  fixtures :payrolls, :payroll_categories, :payroll_items

  test "should see new page" do
    get :new, payroll_id: 1
    assert_response :success
  end

  private
  def current_payroll_item
    @payroll_item ||= payroll_items(:fixture)
  end
end
