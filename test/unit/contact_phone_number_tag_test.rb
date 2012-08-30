# encoding: UTF-8
require 'test_helper'

class ContactPhoneNumberTagTest < ActiveSupport::TestCase
  fixtures :contact_phone_number_tags

  setup do
    @valid_attributes = {
      name: "거래처",
      company_id: 1
    }
  end

  test "ContactPhoneNumber should create contact_phone_number_tag with valid attributes" do
    contact_phone_number_tag = ContactPhoneNumberTag.new(@valid_attributes)
    assert contact_phone_number_tag.valid?
  end

  test "ContactPhoneNumber shouldn't create contact_phone_number_tag with invalid attributes" do
    contact_phone_number_tag = ContactPhoneNumberTag.new(@valid_attributes)
    contact_phone_number_tag.name = "집"
    assert contact_phone_number_tag.invalid?
  end
end