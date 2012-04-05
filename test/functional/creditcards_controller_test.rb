require 'test_helper'

class CreditcardsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:creditcards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create creditcard" do
    assert_difference('Creditcard.count') do
      post :create, :creditcard => { }
    end

    assert_redirected_to creditcard_path(assigns(:creditcard))
  end

  test "should show creditcard" do
    get :show, :id => creditcards(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => creditcards(:one).to_param
    assert_response :success
  end

  test "should update creditcard" do
    put :update, :id => creditcards(:one).to_param, :creditcard => { }
    assert_redirected_to creditcard_path(assigns(:creditcard))
  end

  test "should destroy creditcard" do
    assert_difference('Creditcard.count', -1) do
      delete :destroy, :id => creditcards(:one).to_param
    end

    assert_redirected_to creditcards_path
  end
end
