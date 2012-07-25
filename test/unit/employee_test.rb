require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  fixtures :accounts

  class Account < ActiveRecord::Base
    def admin?
      true
    end
  end

  test "Employee should get joined and retired member list" do
    Employee.destroy_all
    account = Account.first

    joined  = Employee.create(juminno: "830101-1010110", joined_on: Date.today)
    retired = Employee.create(juminno: "830101-1010111", joined_on: Date.today, retired_on: Date.today)

    assert_equal([joined], Employee.search_by_type(account, :join))
    assert_equal([retired], Employee.search_by_type(account, :retire))
  end
end