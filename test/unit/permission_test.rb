# encoding: UTF-8
require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  fixtures :permissions

  setup do
    @valid_attributes = {
      name: "test"
    }
  end

  test "Permission should create permission with valid attributes" do
    permission = Permission.new(@valid_attributes)
    assert permission.valid?
  end

  test "Permission shouldn't create permission with invalid attributes" do
    permission = Permission.new(@valid_attributes)
    permission.name = nil
    assert permission.invalid?

    permission = Permission.new(@valid_attributes)
    permission.name = "bank_accounts"
    assert permission.invalid?
  end
end