require 'test_helper'

class CreditcardsControllerTest < ActionController::TestCase
  fixtures :creditcards

  test "should see list page" do
    get :index
    assert_response :success
  end

  test "should see credit card page" do
    get :show, id: current_creditcard.id
    assert_response :success
  end

  test "should see new credit card page" do
    get :new, id: current_creditcard.id
    assert_response :success
  end

  test "should see edit credit card page" do
    get :edit, id: current_creditcard.id
    assert_response :success
  end

  test "should see total page" do
    get :total
    assert_response :success
  end
  
  def current_creditcard
    @creditcard ||= creditcards(:shinhan_card)
  end
end