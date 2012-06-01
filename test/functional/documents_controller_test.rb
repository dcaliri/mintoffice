require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
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
  end

  test "should edit document" do
    get :edit, :id => current_document.id
    assert_response :success
  end

  private
  def current_document
    @document ||= current_company.documents.create!(title: 'HAHA')
  end
end
