require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  fixtures :users, :hrinfos, :payments

  def setup
    current_user.permission.create!(name: 'payments')
  end

  test "should see index page" do
    get :index, user_id: 1
    assert_response :success
  end

  test "should see new page" do
    get :new, user_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, user_id: 1, :id => current_payment.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, user_id: 1, :id => current_payment.id
    assert_response :success
  end

  # test "should see yearly page" do
  #   get :yearly, user_id: 1
  #   assert_response :success
  # end
  #
  # test "should see new yearly page" do
  #   get :new_yearly, user_id: 1
  #   assert_response :success
  # end
  #
  # test "should see new yearly page" do
  #   get :bonus, user_id: 1
  #   assert_response :success
  # end

  private
  def current_payment
    @payment ||= payments(:fixture)
  end
end
