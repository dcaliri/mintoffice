require 'test_helper'

class InvestmentsControllerTest < ActionController::TestCase
  fixtures :investments

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_investment.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_investment.id
    assert_response :success
  end

  private
  def current_investment
    @investment ||= investments(:fixture)
  end
end
