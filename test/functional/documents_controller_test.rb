require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  fixtures :documents

  def setup
    current_user.permission.create!(name: 'documents')
  end

  test "should index document list" do
    get :index
    assert_response :success
  end

  test "should show new document form" do
    get :new
    assert_response :success
  end

  test "should show document" do
    get :show, :id => current_document.id
    assert_response :success
  end

  test "should edit document" do
    get :edit, :id => current_document.id
    assert_response :success
  end

  private
  def current_document
    @document ||= documents(:fixture)
  end
end
