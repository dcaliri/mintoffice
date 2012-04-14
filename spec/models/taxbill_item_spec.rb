require 'spec_helper'

describe TaxbillItem do
  def item
    @item ||= TaxbillItem.new do |client|
      client.quantity = 1
    end
  end

  it "should create a new instance" do
    item.should be_valid
  end

  it "shouldn't create a new instance if quantity is less than zero" do
    item.quantity = 0
    item.should be_invalid

    item.quantity = -1
    item.should be_invalid
  end

end