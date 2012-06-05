require 'test_helper'

class CardbillsControllerTest < ActionController::TestCase
  fixtures :cardbills

  def setup
    current_user.permission.create!(name: 'cardbills')
  end

  test "should index document list" do
    get :index
    assert_response :success
  end

  test "should show new document form" do
    get :new
    assert_response :success
  end

  test "should show document" do
    get :show, :id => current_cardbill.id
    assert_response :success
  end

  test "should edit document" do
    get :edit, :id => current_cardbill.id
    assert_response :success
  end

  private
  def current_cardbill
    @cardbill ||= cardbills(:fixture)
  end
end
