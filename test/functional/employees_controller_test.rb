require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  fixtures :employees, :attachments

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
    get :show, :id => current_employee.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_employee.id
    assert_response :success
  end

  test "should see find_contact page" do
    get :find_contact
    assert_response :success
  end

  test "should see employment proof page" do
    get :new_employment_proof, :id => current_employee.id
    assert_response :success
  end

  test "should get employment proof" do
    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end
    
    get :employment_proof, :id => current_employee.id, purpose: "test"
    assert_response :success
  end

  private
  def current_employee
    @employee ||= employees(:fixture)
  end
end
