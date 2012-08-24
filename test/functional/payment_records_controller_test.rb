require 'test_helper'

class PaymentRecordsControllerTest < ActionController::TestCase
  fixtures :payment_records

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_payment_record.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_payment_record.id
    assert_response :success
  end

  private
  def current_payment_record
    @payment_record ||= payment_records(:fixture)
  end
end
