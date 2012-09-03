require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  fixtures :contacts
  fixtures :contact_emails
  fixtures :contact_email_tags
  fixtures :contact_email_tags_contact_emails
  fixtures :contact_addresses
  fixtures :contact_address_tags
  fixtures :contact_address_tags_contact_addresses
  fixtures :contact_phone_numbers
  fixtures :contact_phone_number_tags
  fixtures :contact_phone_number_tags_contact_phone_numbers
  fixtures :contact_others
  fixtures :contact_other_tags
  fixtures :contact_other_tags_contact_others

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
    assert_select '#descr dl dd a', 3

    ContactAddress.destroy_all

    get :show, :id => current_contact.id
    assert_response :success
    assert_select '#descr dl dd a', 2

    ContactEmail.destroy_all

    get :show, :id => current_contact.id
    assert_response :success
    assert_select '#descr dl dd a', 1

    ContactPhoneNumber.destroy_all

    get :show, :id => current_contact.id
    assert_response :success
    assert_select '#descr dl dd a', 0
  end

  test "should see edit page" do
    get :edit, :id => current_contact.id
    assert_response :success
  end

  private
  def current_contact
    @contact ||= contacts(:fixture)
  end
end
