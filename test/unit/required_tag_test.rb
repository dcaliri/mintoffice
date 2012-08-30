# encoding: UTF-8
require 'test_helper'

class RequiredTagTest < ActiveSupport::TestCase
  fixtures :required_tags

  setup do
    @valid_attributes = {
      modelname: "Document",
      tag_id: 1
    }
  end

  test "RequirdTag should create required_tag with valid attributes" do
    required_tag = RequiredTag.new(@valid_attributes)
    assert required_tag.valid?
  end

  test "RequiredTag shouldn't create required_tag with invalid attributes" do
    required_tag = RequiredTag.new(@valid_attributes)
    required_tag.modelname = "Employee"
    assert required_tag.invalid?
  end
end