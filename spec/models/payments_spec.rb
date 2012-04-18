require 'spec_helper'

describe Payment do
  def make_params
    after = {
      "0" => "0",
      "1" => "0",
      "2" => "0",
      "3" => "0",
      "4" => "0",
      "5" => "0",
      "6" => "0",
      "7" => "0",
      "8" => "0",
      "9" => "0",
      "10" => "0",
      "11" => "0"
    }
    @params = {
      "pay_start(1i)"=>"2012",
      "pay_start(2i)"=>"4",
      "pay_start(3i)"=>"1",
      "total" => "1200",
      "after" => after
    }
    @params
  end

  def params
    @params ||= make_params
  end

  describe "#create_yearly" do
    it "should create from 2012-4" do
      Payment.create_yearly!(params)
      Payment.first.pay_at.should == DateTime.new(2012, 4, 1)
    end

    it "should create to 2013-3" do
      Payment.create_yearly!(params)
      Payment.last.pay_at.should == DateTime.new(2013, 3, 1)
    end

    context "without bonus" do
      it "should create twelve payments" do
        Payment.create_yearly!(params)
        Payment.count.should == 12
      end

      it "should 100 amount of default payment unless bonus" do
        Payment.create_yearly!(params)
        Payment.first.amount.to_i.should == 100
      end
    end

    context "with bonus" do
      def make_params
        result = super
        result["after"]["0"] = "10"
        result["after"]["11"] = "10"
        result
      end

      it "should create fourteen payments" do
        Payment.create_yearly!(params)
        Payment.count.should == 14
      end

      it "should 80 amount of default payment" do
        Payment.create_yearly!(params)
        Payment.first.amount.to_i.should == 80
      end

      it "should 120 amount of payment when december" do
        Payment.create_yearly!(params)
        Payment.last.amount.to_i.should == 120
      end
    end
  end

  describe "#total_bonus" do
    it "should return 0 if no bonus" do
      Payment.total_bonus(make_params["after"]).should == 0
    end

    it "should return 10 if bonus is 10-10" do
      after = make_params["after"]
      after["0"] = 10
      after["11"] = 10
      Payment.total_bonus(after).should == 20
    end
  end

  describe "#basic_payment" do
    it "should 100 amount of payment unless bonus" do
      Payment.basic_payment(make_params).should == 100
    end
  end
end