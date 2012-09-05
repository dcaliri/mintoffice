# encoding: UTF-8
require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  fixtures :enrollments

  setup do
    Company.current_company = Company.first

    @valid_attributes = {
      firstname: "관리",
      lastname: "김",
      company_name: "Mintech",
      position: "사장",
      department: "민트기술",
    }

    @contact_address = {
      other1: "서울시 강남구 신사동"
    }

    @contact_phone = {
      number: "010-1234-1234"
    }

    @contact_email = {
      email: "test@test.com"
    }
  end

  test "Contact should create contact with valid attributes" do
    contact = Contact.new(@valid_attributes)
    contact.addresses.build(@contact_address)
    contact.emails.build(@contact_email)
    contact.phone_numbers.build(@contact_phone)
    assert contact.valid?

    contact = Contact.new(@valid_attributes)
    assert contact.valid?

    contact = Contact.new(@valid_attributes)
    contact.validate_additional_info = true
    assert contact.invalid?
  end

  test "Contact shouldn't validate contact without address/email/phone_number" do
    contact = Contact.new(@valid_attributes)
    contact.validate_additional_info = true
    contact.addresses.build(@contact_address)
    contact.emails.build(@contact_email)
    contact.phone_numbers.build(@contact_phone)
    assert contact.valid?

    contact = Contact.new(@valid_attributes)
    contact.validate_additional_info = true
    contact.emails.build(@contact_email)
    contact.phone_numbers.build(@contact_phone)
    assert contact.invalid?

    contact = Contact.new(@valid_attributes)
    contact.validate_additional_info = true
    contact.addresses.build(@contact_address)
    contact.phone_numbers.build(@contact_phone)
    assert contact.invalid?

    contact = Contact.new(@valid_attributes)
    contact.validate_additional_info = true
    contact.addresses.build(@contact_address)
    contact.emails.build(@contact_email)
    assert contact.invalid?
  end

  private
  def current_person
    @person ||= people(:fixture)
  end
end