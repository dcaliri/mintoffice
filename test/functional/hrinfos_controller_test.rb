require 'test_helper'

class HrinfosControllerTest < ActionController::TestCase
  fixtures :hrinfos, :attachments

  def setup
    current_user.hrinfo.permission.create!(name: 'hrinfos')
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see index page of retired member" do
    get :index, search_type: :retire
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_hrinfo.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_hrinfo.id
    assert_response :success
  end

  test "should see employment proof page" do
    get :new_employment_proof, :id => current_hrinfo.id
    assert_response :success
  end

  private
  def current_hrinfo
    @hrinfo ||= hrinfos(:fixture)
  end
end
