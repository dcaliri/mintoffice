require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "Account should have account name" do
    account = Account.new
    assert account.invalid?
  end
end