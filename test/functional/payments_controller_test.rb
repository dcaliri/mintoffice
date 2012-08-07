require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  fixtures :accounts, :employees, :payments

  test "should see index page" do
    get :index, employee_id: 1
    assert_response :success
  end

  test "should see new page" do
    get :new, employee_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, employee_id: 1, :id => current_payment.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, employee_id: 1, :id => current_payment.id
    assert_response :success
  end

  # test "should see yearly page" do
  #   get :yearly, account_id: 1
  #   assert_response :success
  # end
  #
  # test "should see new yearly page" do
  #   get :new_yearly, account_id: 1
  #   assert_response :success
  # end
  #
  # test "should see new yearly page" do
  #   get :bonus, account_id: 1
  #   assert_response :success
  # end

  private
  def current_payment
    @payment ||= payments(:fixture)
  end
end
