require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  fixtures :accounts
  fixtures :employees

  setup do
    @valid_attributes = {
      joined_on: "2012-07-18",
      person_id: 1,
      companyno: 7,
      juminno: "121211-1234567",
      listed: false
    }
  end

  class Account < ActiveRecord::Base
    def admin?
      true
    end
  end

  test "Employee should get joined and retired member list" do
    Employee.destroy_all
    account = Account.first

    joined  = Employee.create(juminno: "830101-1010110", companyno: 1, joined_on: Date.today)
    retired = Employee.create(juminno: "830101-1010111", companyno: 2, joined_on: Date.today, retired_on: Date.today)

    assert_equal([joined], Employee.search_by_type(account, :join))
    assert_equal([retired], Employee.search_by_type(account, :retire))
  end

  test "Employee should create employee with valid attributes" do
    employee = Employee.new(@valid_attributes)
    assert employee.valid?
  end

  test "Employee shouldn't create employee with invalid attributes" do
    employee = Employee.new(@valid_attributes)
    employee.juminno = "1234567-123456"
    assert employee.invalid?

    employee = Employee.new(@valid_attributes)
    employee.juminno = "123456-1234567"
    assert employee.invalid?

    employee = Employee.new(@valid_attributes)
    employee.companyno = 1
    assert employee.invalid?
  end
end