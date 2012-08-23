require 'test_helper'

class BankbooksControllerTest < ActionController::TestCase
  fixtures :bankbooks

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_bankbook.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_bankbook.id
    assert_response :success
  end

  private
  def current_bankbook
    @bankbook ||= bankbooks(:shinhan)
  end
end
