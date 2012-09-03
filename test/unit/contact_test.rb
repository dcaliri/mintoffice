# encoding: UTF-8
require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  fixtures :companies
  fixtures :people
  fixtures :enrollments
  fixtures :companies

  setup do
    @valid_attributes = {
      firstname: "관리",
      lastname: "김",
      company_name: nil,
      position: "사장",
      department: "민트기술",
      email_list: nil,
      person_id: 0,
      migrated_data: false,
      owner_id: nil,
      isprivate: false,
      company_id: 1,
      google_id: nil,
      google_etag: nil
    }

    Person.current_person = people(:fixture)
  end

  test "Contact should create contact with valid attributes" do
    Company.current_company = Company.first
    contact = Contact.new(@valid_attributes)

    assert contact.valid?
  end

  #test "Contact shouldn't create contact with invalid attributes" do
  #  contact = Contact.create!(@valid_attributes)
  #  contact.person_id = 11
  #  assert contact.invalid?
  #end
end