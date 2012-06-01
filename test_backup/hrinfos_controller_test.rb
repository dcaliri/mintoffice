require 'test_helper'

class HrinfosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hrinfos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hrinfo" do
    assert_difference('Hrinfo.count') do
      post :create, :hrinfo => { }
    end

    assert_redirected_to hrinfo_path(assigns(:hrinfo))
  end

  test "should show hrinfo" do
    get :show, :id => hrinfos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => hrinfos(:one).to_param
    assert_response :success
  end

  test "should update hrinfo" do
    put :update, :id => hrinfos(:one).to_param, :hrinfo => { }
    assert_redirected_to hrinfo_path(assigns(:hrinfo))
  end

  test "should destroy hrinfo" do
    assert_difference('Hrinfo.count', -1) do
      delete :destroy, :id => hrinfos(:one).to_param
    end

    assert_redirected_to hrinfos_path
  end
end
