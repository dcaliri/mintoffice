# encoding: UTF-8
require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  fixtures :documents
  fixtures :document_owners
  fixtures :documents_tags
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :tags
  fixtures :taggings
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :access_people
  fixtures :business_clients
  fixtures :taxmen
  fixtures :contacts
  fixtures :contact_phone_numbers
  fixtures :contact_emails

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should'n see index page with another company" do
    get :index
    assert_response :success
    
    assert_select '#list-table tr td', '테스트 문서'
    assert_select '#list-table tr td', '유저 정보 문서'
    assert_select '#list-table tr td', {count: 0, text: "다른 회사 문서"}

    # switch_to_another_company

    # assert Person.current_person.id == 12
    # assert Company.current_company.id == 2

    # get :index
    # assert_response :success

    # assert_select '#list-table', '다른 회사 문서'
    # assert_select '#list-table tr td', {count: 0, text: "테스트 문서"}
    # assert_select '#list-table tr td', {count: 0, text: "유저 정보 문서"}
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
