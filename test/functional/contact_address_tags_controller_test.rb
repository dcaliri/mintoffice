require 'test_helper'

class ContactAddressTagsControllerTest < ActionController::TestCase
  test "should see new page" do
    get :new
    assert_response :success
  end
end
