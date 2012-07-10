require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User should have user name" do
    user = User.new
    assert user.invalid?
  end
end