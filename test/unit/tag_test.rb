# encoding: UTF-8
require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :tags

  setup do
    @valid_attributes = {
      name: "tag_test",
      company_id: 1
    }
  end

  test "Tag should create tag with valid attributes" do
    tag = Tag.new(@valid_attributes)
    assert tag.valid?
  end

  test "Tag shouldn't create tag with invalid attributes" do
    tag = Tag.new(@valid_attributes)
    tag.name = "test"
    assert tag.invalid?
  end
end