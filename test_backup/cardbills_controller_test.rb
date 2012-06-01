require 'test_helper'

class CardbillsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cardbills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cardbill" do
    assert_difference('Cardbill.count') do
      post :create, :cardbill => { }
    end

    assert_redirected_to cardbill_path(assigns(:cardbill))
  end

  test "should show cardbill" do
    get :show, :id => cardbills(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cardbills(:one).to_param
    assert_response :success
  end

  test "should update cardbill" do
    put :update, :id => cardbills(:one).to_param, :cardbill => { }
    assert_redirected_to cardbill_path(assigns(:cardbill))
  end

  test "should destroy cardbill" do
    assert_difference('Cardbill.count', -1) do
      delete :destroy, :id => cardbills(:one).to_param
    end

    assert_redirected_to cardbills_path
  end
end
