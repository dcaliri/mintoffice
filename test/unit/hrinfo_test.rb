require 'test_helper'

class HrInfoTest < ActiveSupport::TestCase
  fixtures :users

  class User < ActiveRecord::Base
    def admin?
      true
    end
  end

  test "Hrinfo should get joined and retired member list" do
    Hrinfo.destroy_all
    user = User.first

    joined  = Hrinfo.create(juminno: "830101-1010110", joined_on: Date.today)
    retired = Hrinfo.create(juminno: "830101-1010111", joined_on: Date.today, retired_on: Date.today)

    assert_equal([joined], Hrinfo.search_by_type(user, :join))
    assert_equal([retired], Hrinfo.search_by_type(user, :retire))
  end
end