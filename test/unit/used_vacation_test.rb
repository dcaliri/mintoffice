require 'test_helper'

class UsedVacationTest < ActiveSupport::TestCase
  fixtures :users#, :groups_users, :groups

  test "UsedVacation during should retreive correct vacation list" do
    User.current_user = User.first
    
    far_before_startDate = Date.new(2010, 5, 1)
    before_startDate = Date.new(2010, 5, 3)
    startDate = Date.new(2010, 5, 5)
    betweenDate = Date.new(2010, 5, 7)
    betweenDate2 = Date.new(2010, 5, 8)
    endDate = Date.new(2010, 5, 10)
    after_endDate = Date.new(2010, 5, 15)
    far_after_endDate = Date.new(2010, 5, 20)

    far_before_and_before = UsedVacation.create(from:far_before_startDate, to:before_startDate, note:"1", period:1)
    after_and_far_after = UsedVacation.create(from:after_endDate, to:far_after_endDate, note:"1", period:1)

    before_and_between = UsedVacation.create(from:before_startDate, to:betweenDate, note:"1", period:1)
    between_and_after = UsedVacation.create(from:betweenDate, to:after_endDate, note:"1", period:1)
    between_and_between2 = UsedVacation.create(from:betweenDate, to:betweenDate2, note:"1", period:1)
    before_and_after = UsedVacation.create(from:before_startDate, to:after_endDate, note:"1", period:1)

    assert_equal(UsedVacation.during(startDate..endDate), [before_and_between, between_and_after, between_and_between2, before_and_after])
  end
end