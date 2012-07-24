require 'test_helper'

class CommuteTest < ActiveSupport::TestCase
  fixtures :users, :people, :hrinfos

  test "Commute can duplicated from yesterday to today" do
    user = User.first

    yesterday = (Time.now - 1.day).change(hour: 11, minutes: 59)
    today = Time.now.change(hour: 0, minutes: 1)

    before = user.hrinfo.commutes.build(go: yesterday)
    after = user.hrinfo.commutes.build(go: today)

    before.save!
    assert after.valid?
  end

  test "Commute can't duplicated between the attend" do
    user = User.first

    before_attend = Time.now.change(hour: 8, minutes: 59)
    after_attend = Time.now.change(hour: 9, minutes: 1)

    before = user.hrinfo.commutes.build(go: before_attend)
    after = user.hrinfo.commutes.build(go: after_attend)

    before.save!
    assert after.invalid?
  end
end