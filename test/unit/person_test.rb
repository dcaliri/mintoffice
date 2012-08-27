require 'test_helper'

class PersonTest < ActiveSupport::TestCase
	fixtures :people
	fixtures :accounts
	fixtures :employees
	fixtures :contacts

  test "should show employee name and accout name" do
    admin_name = "#{admin_person.employee.fullname}(#{admin_person.account.name})"
    no_employee_name = "no employee"
    assert_equal(admin_person.name, admin_name)
    assert_equal(no_employee_person.name, no_employee_name)
  end

  private
  def admin_person
    @admin ||= people(:fixture)
  end

  def no_employee_person
    @no_employee ||= people(:no_employee)
  end
end