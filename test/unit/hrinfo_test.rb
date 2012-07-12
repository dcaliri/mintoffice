require 'test_helper'

class HrInfoTest < ActiveSupport::TestCase
  fixtures :users, :groups_users, :groups

  test "Hrinfo should get joined and retired member list" do
    user = User.first

    joined  = Hrinfo.create(juminno: "830101-1010110", firstname: "A", lastname: "B", joined_on: Date.today)
    retired = Hrinfo.create(juminno: "830101-1010111", firstname: "A", lastname: "B", joined_on: Date.today, retired_on: Date.today)

    assert_equal(Hrinfo.search_by_type(user, :join), [joined])
    assert_equal(Hrinfo.search_by_type(user, :retire), [retired])
  end
end