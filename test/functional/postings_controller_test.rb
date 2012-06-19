require 'test_helper'

class PostingsControllerTest < ActionController::TestCase
  fixtures :postings

  def setup
    current_user.permission.create!(name: 'documents')
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_posting.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_posting.id
    assert_response :success
  end

  private
  def current_posting
    @document ||= postings(:fixture)
  end
end
