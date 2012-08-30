# encoding: UTF-8
require 'test_helper'

class ContactAddressTagTest < ActiveSupport::TestCase
  fixtures :contact_address_tags

  setup do
    @valid_attributes = {
      name: "거래처",
      company_id: 1
    }
  end

  test "ContactAddressTag should create contact_address_tag with valid attributes" do
    contact_address_tag = ContactAddressTag.new(@valid_attributes)
    assert contact_address_tag.valid?
  end

  test "ContactAddressTag shouldn't create contact_address_tag with invalid attributes" do
    contact_address_tag = ContactAddressTag.new(@valid_attributes)
    contact_address_tag.name = "집"
    assert contact_address_tag.invalid?
  end
end