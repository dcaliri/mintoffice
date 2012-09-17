require 'test_helper'

class BankbooksControllerTest < ActionController::TestCase
  fixtures :bankbooks

  setup do
    @valid_attributes = {
      name: "test",
      number: "123-321-123",
      account_holder: "test"
    }

    @invalid_attributes = {
      name: "test",
      number: nil,
      account_holder: "test"
    }
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should create a new bankbook" do
    post :create, bankbook: @valid_attributes
    assert_response :redirect
  end

  test "should fail to create a new bankbook" do
    post :create, bankbook: @invalid_attributes
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

  test "should update bankbook" do
    get :update, :id => current_bankbook.id, bankbook: @valid_attributes
    assert_response :redirect
  end

  test "should fail to update bankbook" do
    get :update, :id => current_bankbook.id, bankbook: @invalid_attributes
    assert_response :success
  end

  test "should destroy bankbook" do
    get :destroy, :id => current_bankbook.id
    assert_response :redirect
  end

  private
  def current_bankbook
    @bankbook ||= bankbooks(:shinhan)
  end
end
