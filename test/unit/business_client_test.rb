# encoding: UTF-8
require 'test_helper'

class BusinessClientTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: "테스트 거래처",
      registration_number: "123-321-1234",
      category: "테스트",
      business_status: "테스트 모듈",
      address: "MAC OS",
      owner: "MINT",
      company_id: 1
    }
  end

  test "BusinessClient should create business_client with valid attributes" do
    business_client = BusinessClient.new(@valid_attributes)
    assert business_client.valid?
  end

  test "BusinessClient shouldn't create business_client with invalid attributes" do
    business_client = BusinessClient.new(@valid_attributes)
    business_client.name = nil
    assert business_client.invalid?
  end
end