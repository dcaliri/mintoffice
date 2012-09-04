# encoding: UTF-8
require 'test_helper'

class RequiredTagsControllerTest < ActionController::TestCase
  fixtures :required_tags
  fixtures :tags

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end
end
