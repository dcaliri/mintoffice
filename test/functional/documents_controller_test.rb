require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  def setup
    User.destroy_all
    @user = User.create!(name: "admin", password: "1234", password_confirmation: "1234")
    @user.permission.create!(name: 'documents')

    Company.destroy_all
    @company = Company.create!(name: "minttech")

    session[:user_id] = @user.id
    session[:company_id] = @company.id

    User.current_user = @user
    Company.current_company = @company

    Document.destroy_all
    @document = @company.documents.create!(title: 'HAHA')
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
    get :show, :id => @document.id
  end

  test "should edit document" do
    get :edit, :id => @document.id
    assert_response :success
  end
end
