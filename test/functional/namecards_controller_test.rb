require 'test_helper'

class NamecardsControllerTest < ActionController::TestCase
  fixtures :namecards

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_namecard.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_namecard.id
    assert_response :success
  end

  private
  def current_namecard
    @namecard ||= namecards(:fixture)
  end
end
