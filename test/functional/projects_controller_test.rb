require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  fixtures :companies, :projects

  def setup
    current_user.permission.create!(name: 'projects')
  end

  test "should see index page" do
    get :index
    assert_response :success
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
