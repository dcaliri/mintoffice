require 'test_helper'

class HrInfoTest < ActiveSupport::TestCase
  test "Hrinfo should get joined and retired member list" do
    joined  = Hrinfo.create(juminno: "830101-1010110", firstname: "A", lastname: "B", joined_on: Date.today)
    retired = Hrinfo.create(juminno: "830101-1010111", firstname: "A", lastname: "B", joined_on: Date.today, retired_on: Date.today)

    assert_equal(Hrinfo.search_by_type(:join), [joined])
    assert_equal(Hrinfo.search_by_type(:retire), [retired])
  end
end