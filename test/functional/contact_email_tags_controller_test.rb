# encoding: UTF-8
require 'test_helper'

class ContactEmailTagsControllerTest < ActionController::TestCase
  test "should see new page" do
    get :new
    assert_response :success
  end
end
