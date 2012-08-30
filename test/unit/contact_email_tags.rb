# encoding: UTF-8
require 'test_helper'

class ContactEmailTagTest < ActiveSupport::TestCase
  fixtures :contact_email_tags

  setup do
    @valid_attributes = {
      name: "거래처",
      company_id: 1
    }
  end

  test "ContactEmailTag should create contact_email_tag with valid attributes" do
    contact_email_tag = ContactEmailTag.new(@valid_attributes)
    assert contact_email_tag.valid?
  end

  test "ContactEmailTag shouldn't create contact_email_tag with invalid attributes" do
    contact_email_tag = ContactEmailTag.new(@valid_attributes)
    contact_email_tag.name = "집"
    assert contact_email_tag.invalid?
  end
end