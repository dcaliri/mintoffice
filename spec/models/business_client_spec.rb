require 'spec_helper'

describe BusinessClient do
  def business_client
    @business_client ||= BusinessClient.new do |client|
      client.name = "my client"
    end
  end

  it "should create a new instance" do
    business_client.should be_valid
  end

  it "shouldn't create a new instance if name is blank" do
    business_client.name = ""
    business_client.should be_invalid
  end
end