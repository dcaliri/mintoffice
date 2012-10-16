# encoding: UTF-8
require 'test_helper'

class CardbillsControllerTest < ActionController::TestCase
  fixtures :cardbills

  setup do
    @valid_attributes = {
      transdate: "#{Time.zone.now}",
      amount: 10908,
      totalamount: 12000,
      storename: "test",
      approveno: "27001012",
      creditcard_id: 1
    }

    @invalid_attributes = {
      transdate: "#{Time.zone.now}",
      amount: 10908,
      totalamount: nil,
      storename: "test",
      approveno: "27001012",
      creditcard_id: 1
    }
  end

  test "should index document list" do
    get :index
    assert_response :success
  end

  test "should show new document form" do
    get :new
    assert_response :success
  end

  test "should create a new cardbill" do
    post :create, cardbill: @valid_attributes
    assert_response :redirect

    get :index
    assert_response :success

    assert_equal flash[:notice], I18n.t("common.messages.created", :model => Cardbill.model_name.human)
  end

  test "should fail to create a new cardbill" do
    post :create, cardbill: @invalid_attributes
    assert_response :success
  end

  test "should show document" do
    get :show, :id => current_cardbill.id
    assert_response :success

    assert_select '.box #descr #show_command a', 1
    assert_select '.box #descr #show_command', "사용내역 보기"
  end

  test "should edit document" do
    get :edit, :id => current_cardbill.id
    assert_response :success
  end

  test "should update cardbill" do
    get :update, :id => current_cardbill.id, cardbill: @valid_attributes
    assert_response :redirect

    get :index
    assert_response :success

    assert_equal flash[:notice], I18n.t("common.messages.updated", :model => Cardbill.model_name.human)
  end

  test "should fail to update cardbill" do
    get :update, :id => current_cardbill.id, cardbill: @invalid_attributes
    assert_response :success
  end

  test "should destroy cardbill" do
    get :destroy, :id => current_cardbill.id
    assert_response :redirect
  end

  private
  def current_cardbill
    @cardbill ||= cardbills(:has_permission_cardbill)
  end
end
