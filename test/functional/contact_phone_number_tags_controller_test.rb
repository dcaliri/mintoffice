# encoding: UTF-8
require 'test_helper'

class ContactPhoneNumberTagsControllerTest < ActionController::TestCase
  test "should see new page" do
    get :new
    assert_response :success
  end
end
