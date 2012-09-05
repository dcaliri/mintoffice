require 'test_helper'

class PromissoriesControllerTest < ActionController::TestCase
  fixtures :promissories

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_promissories.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_promissories.id
    assert_response :success
  end

  private
  def current_promissories
    @promissories ||= promissories(:fixture)
  end
end
