require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  fixtures :contacts

  def setup
    current_user.permission.create!(name: 'contacts')
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
    get :show, :id => current_contact.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_contact.id
    assert_response :success
  end

  test "should see find page" do
    get :find
    assert_response :success
  end

  private
  def current_contact
    @contact ||= contacts(:fixture)
  end
end