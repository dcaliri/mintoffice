require 'test_helper'

class PettycashesControllerTest < ActionController::TestCase
  fixtures :pettycashes

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_pettycash.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_pettycash.id
    assert_response :success
  end

  private
  def current_pettycash
    @pettycash ||= pettycashes(:fixture)
  end
end
