require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  fixtures :documents

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_document.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_document.id
    assert_response :success
  end

  private
  def current_document
    @document ||= documents(:fixture)
  end
end
