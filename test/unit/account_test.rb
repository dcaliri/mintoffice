require 'test_helper'

class AccountTest < ActiveSupport::TestCase
	fixtures :accounts

	setup do
    @valid_attributes = {
      name: "test",
      hashed_password: "96043f0adf13e8d440a0e90ec7a2b7757a16bc2c",
      salt: "21757029800.1164294613723833",
      daum_account: "test@daum.net",
      nate_account: "test@nate.net",
      google_account: "test@google.com"
    }
  end

  test "Account should create account with valid attributes" do
    account = Account.new(@valid_attributes)
    assert account.valid?
  end

	test "Account shouldn't create account with invalid attributes" do
    account = Account.new(@valid_attributes)
    account.name = nil
    assert account.invalid?

    account = Account.new(@valid_attributes)
    account.name = "admin"
    assert account.invalid?

    account = Account.new(@valid_attributes)
    account.daum_account = "daum_account_user@hanmail.com"
    assert account.invalid?

    account = Account.new(@valid_attributes)
    account.nate_account = "nate_account_user@lycos.co.kr"
    assert account.invalid?

    account = Account.new(@valid_attributes)
    account.google_account = "google_account_user@wangsy.com"
    assert account.invalid?

    account = Account.new(@valid_attributes)
    account.hashed_password = nil
    assert account.invalid?
  end
end