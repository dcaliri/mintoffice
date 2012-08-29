require 'test_helper'

class TaxbillsControllerTest < ActionController::TestCase
  fixtures :taxbills, :taxmen, :business_clients

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see total page" do
    get :total
    assert_response :success
  end

  test "should see new page" do
    get :new
    assert_response :success
  end

  test "should see show page" do
    get :show, :id => current_taxbill.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_taxbill.id
    assert_response :success
  end

  private
  def current_taxbill
    @taxbill ||= taxbills(:purchase)
  end
end
