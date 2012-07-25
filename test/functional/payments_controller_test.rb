require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  fixtures :accounts, :employees, :payments

  def setup
    current_account.employee.permission.create!(name: 'payments')
  end

  test "should see index page" do
    get :index, account_id: 1
    assert_response :success
  end

  test "should see new page" do
    get :new, account_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, account_id: 1, :id => current_payment.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, account_id: 1, :id => current_payment.id
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
