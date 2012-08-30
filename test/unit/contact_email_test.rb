# encoding: UTF-8
require 'test_helper'

class ContactEmailTest < ActiveSupport::TestCase
  fixtures :contact_emails

  setup do
    @valid_attributes = {
      contact_id: 1,
      email: "test@test.com"
    }
  end

  test "ContactEmail should create contact_email with valid attributes" do
    contact_email = ContactEmail.new(@valid_attributes)
    assert contact_email.valid?
  end

  test "ContactEmail shouldn't create contact_email with invalid attributes" do
    contact_email = ContactEmail.new(@valid_attributes)
    contact_email.email = "test!test,com"
    assert contact_email.invalid?
  end
end