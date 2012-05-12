require 'spec_helper'

describe UsedVacation do
  describe "##total" do
    def vacation
      @vacation ||= Vacation.create!
    end

    it "should return total period of used" do
      today = Time.zone.now
      vacation.used.create!(period: 1.0)
      vacation.used.create!(period: 2.5)
      vacation.used.create!(period: 5.0)
      vacation.used.total.should == 8.5
    end

    it "should return zero if period is nil" do
      vacation.used.total.should == 0
    end
  end
end