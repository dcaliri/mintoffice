require 'spec_helper'

describe Commute do
  describe "#go!" do
    it "should write go field" do
      commute = Commute.new
      commute.go!
      commute.go.should be_within(0.1).of(Time.zone.now)
    end

    it "shouldn't write go field twice" do
      commute = Commute.new
      commute.go!
      expect { commute.go! }.should raise_error
    end
  end

  describe "#leave!" do
    it "should write leave field" do
      commute = Commute.new
      commute.leave!
      commute.leave.should be_within(0.1).of(Time.zone.now)
    end

    it "shouldn't write leave field twice" do
      commute = Commute.new
      commute.leave!
      expect { commute.leave! }.should raise_error
    end
  end
end