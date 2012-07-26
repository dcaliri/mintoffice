require 'test_helper'

class DayworkerTaxesControllerTest < ActionController::TestCase
  set_fixture_class :dayworker_taxes => 'DayworkerTax'
  fixtures :dayworkers, :dayworker_taxes

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_dayworker_tax.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_dayworker_tax.id
    assert_response :success
  end

  private
  def current_dayworker_tax
    @dayworker_tax ||= dayworker_taxes(:fixture)
  end
end
