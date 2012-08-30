# encoding: UTF-8
require 'test_helper'

class ContactPhoneNumberTest < ActiveSupport::TestCase
  fixtures :contact_phone_numbers

  setup do
    @valid_attributes = {
      number: "010-1234-1234",
      contact_id: 1
    }
  end

  test "ContactPhoneNumber should create contact_phone_number with valid attributes" do
    contact_phone_number = ContactPhoneNumber.new(@valid_attributes)
    assert contact_phone_number.valid?
  end

  test "ContactPhoneNumber shouldn't create contact_phone_number with invalid attributes" do
    contact_phone_number = ContactPhoneNumber.new(@valid_attributes)
    contact_phone_number.number = "010.1234.1234"
    assert contact_phone_number.invalid?
  end
end