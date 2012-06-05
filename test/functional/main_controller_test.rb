require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should see main page" do
    get :index
    assert_response :success
  end
end