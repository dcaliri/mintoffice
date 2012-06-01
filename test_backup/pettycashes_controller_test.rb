# require 'test_helper'
#
# class PettycashesControllerTest < ActionController::TestCase
#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:pettycashes)
#   end
#
#   test "should get new" do
#     get :new
#     assert_response :success
#   end
#
#   test "should create pettycash" do
#     assert_difference('Pettycash.count') do
#       post :create, :pettycash => { }
#     end
#
#     assert_redirected_to pettycash_path(assigns(:pettycash))
#   end
#
#   test "should show pettycash" do
#     get :show, :id => pettycashes(:one).to_param
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get :edit, :id => pettycashes(:one).to_param
#     assert_response :success
#   end
#
#   test "should update pettycash" do
#     put :update, :id => pettycashes(:one).to_param, :pettycash => { }
#     assert_redirected_to pettycash_path(assigns(:pettycash))
#   end
#
#   test "should destroy pettycash" do
#     assert_difference('Pettycash.count', -1) do
#       delete :destroy, :id => pettycashes(:one).to_param
#     end
#
#     assert_redirected_to pettycashes_path
#   end
# end
