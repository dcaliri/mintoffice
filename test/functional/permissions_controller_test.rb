# encoding: UTF-8
require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase
  fixtures :permissions

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should add account" do
    post :addaccount, id: current_permission.name, participant: "person-#{add_account.id}"
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => current_permission.name

    get :show, :id => current_permission.name
    assert_response :success

    assert_select '.notice', '성공적으로 사용자를 등록했습니다.'

    post :addaccount, id: current_permission.name, participant: "person-#{add_account.id}"
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => current_permission.name

    get :show, :id => current_permission.name
    assert_response :success

    assert_select '.alert', '이미 등록된 사용자입니다.'
  end

  test "should see show page" do
    get :show, :id => current_permission.name
    assert_response :success
  end

  test "should remove account" do
    post :addaccount, id: current_permission.name, participant: "person-#{add_account.id}"

    post :removeaccount, id: current_permission.name, participant_type: :person, participant_id: add_account.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => current_permission.name
    
    get :show, :id => current_permission.name
    assert_response :success

    assert_select 'li', {count: 0, text: '김 개똥(normal)'}
  end

  private
  def current_permission
    @current_permission ||= permissions(:commutes)
  end

  def add_account
    @add_account ||= accounts(:normal_account)
  end
end
