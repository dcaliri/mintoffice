require 'spec_helper'

describe Vacation do
  describe "#remain" do
    it "should return remain period of vacation" do
      today = Time.zone.now
      vacation = Vacation.create!(from: today, to: today + 1.year, period: 15)
      vacation.used.create!(period: 1.0)
      vacation.used.create!(period: 1.0)
      vacation.used.create!(period: 2.0)
      vacation.remain.should == 11
    end
  end
end