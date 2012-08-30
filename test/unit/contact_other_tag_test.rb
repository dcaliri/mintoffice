# encoding: UTF-8
require 'test_helper'

class ContactOtherTagTest < ActiveSupport::TestCase
  fixtures :contact_other_tags

  setup do
    @valid_attributes = {
      name: "거래처",
      company_id: 1
    }
  end

  test "ContactOtherTag should create contact_other_tag with valid attributes" do
    contact_other_tag = ContactOtherTag.new(@valid_attributes)
    assert contact_other_tag.valid?
  end

  test "ContactOtherTag shouldn't create contact_other_tag with invalid attributes" do
    contact_other_tag = ContactOtherTag.new(@valid_attributes)
    contact_other_tag.name = "홈페이지"
    assert contact_other_tag.invalid?
  end
end