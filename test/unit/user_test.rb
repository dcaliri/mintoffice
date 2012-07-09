require File.expand_path('../../../config/environment', __FILE__)
require 'rails/test_help'

class UserTest < ActiveSupport::TestCase
  test "User should have user name" do
    user = User.new
    assert user.invalid?
  end
end