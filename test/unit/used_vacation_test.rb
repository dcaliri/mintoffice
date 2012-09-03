require 'test_helper'

class UsedVacationTest < ActiveSupport::TestCase
  fixtures :accounts, :groups_people, :groups
  fixtures :used_vacations

  setup do
    @valid_attributes = {
      vacation_id: 1,
      from: "#{Time.zone.now}",
      to: "#{Time.zone.now}",
      note: "test",
      period: 1
    }
  end

  test "UsedVacation should create used_vacation with valid attributes" do
    used_vacation = UsedVacation.new(@valid_attributes)
    assert used_vacation.valid?
  end

  test "UsedVacation shouldn't create used_vacation with invalid attributes" do
    used_vacation = UsedVacation.new(@valid_attributes)
    used_vacation.period = 0.4

    assert used_vacation.invalid?

    used_vacation = UsedVacation.new(@valid_attributes)
    used_vacation.period = 0.5

    assert used_vacation.valid?

    used_vacation.period = 1.5

    assert used_vacation.valid?

    used_vacation.period = 2.0

    assert used_vacation.valid?
  end

  test "UsedVacation during should retreive correct vacation list" do
    Person.current_person = Person.first

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