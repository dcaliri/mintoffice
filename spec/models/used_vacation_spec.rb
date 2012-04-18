require 'spec_helper'

describe UsedVacation do
  describe "##total" do
    it "should return total period of used" do
      today = Time.zone.now
      UsedVacation.create!(period: 1.0)
      UsedVacation.create!(period: 2.5)
      UsedVacation.create!(period: 5.0)
      UsedVacation.total.should == 8.5
    end

    it "should return zero if period is nil" do
      UsedVacation.total.should == 0
    end
  end
end