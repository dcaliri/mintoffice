require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  fixtures :companies

  test "should see show page" do
    get :show, :id => current_company.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_company.id
    assert_response :success
  end

  private
  def current_company
    @company ||= companies(:fixture)
  end
end
