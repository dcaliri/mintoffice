# encoding: UTF-8
require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  fixtures :projects
  fixtures :project_assign_infos

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should'n see index page with another company" do
    get :index
    assert_response :success
    
    assert_select '#list-table tr td', '테스트 프로젝트'
    assert_select '#list-table tr td', {count: 0, text: "다른 회사 프로젝트"}
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_project.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_project.id
    assert_response :success
  end

  private
  def current_project
    @project ||= projects(:fixture)
  end
end
