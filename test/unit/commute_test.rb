require 'test_helper'

class CommuteTest < ActiveSupport::TestCase
  fixtures :accounts, :people, :employees, :commutes

  setup do
    @valid_attributes = {
      go: "2012-07-18 10:02:13.117074",
      leave: "2012-07-18 18:08:13.117074",
      employee_id: 1
    }
  end

  test "Commute can duplicated from yesterday to today" do
    employee = Employee.first

    yesterday = (Time.now - 1.day).change(hour: 11, minutes: 59)
    today = Time.now.change(hour: 0, minutes: 1)

    before = employee.commutes.build(go: yesterday)
    after = employee.commutes.build(go: today)

    before.save!
    assert after.valid?
  end

  test "Commute can't duplicated between the attend" do
    employee = Employee.first

    before_attend = Time.now.change(hour: 8, minutes: 59)
    after_attend = Time.now.change(hour: 9, minutes: 1)

    before = employee.commutes.build(go: before_attend)
    after = employee.commutes.build(go: after_attend)

    before.save!
    assert after.invalid?
  end

  test "Commute should create commute with valid attributes" do
    commute = Commute.new(@valid_attributes)
    assert commute.valid?
  end

  #test "should check to validate unique date" do
  #  commute = Commute.new(@valid_attributes)
  #  commute.leave = nil
  #  assert commute.invalid?
  #end
end