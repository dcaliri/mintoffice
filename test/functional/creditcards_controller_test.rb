require 'test_helper'

class CreditcardsControllerTest < ActionController::TestCase
  def setup
    current_user.permission.create!(name: 'creditcards')
  end

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

  test "should see excel page" do
    get :excel
    assert_response :success
  end

  def current_creditcard
    @creditcard ||= Creditcard.create!({
      cardno: 1,
      expireyear: 1,
      expiremonth: 1,
      nickname: 1,
      issuer: 1,
      cardholder: 1,
    })
  end
end