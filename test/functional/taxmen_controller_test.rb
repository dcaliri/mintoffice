require 'test_helper'

class TaxmenControllerTest < ActionController::TestCase
  fixtures :business_clients, :taxmen

  test "should see find_contact page" do
    get :find_contact, business_client_id: current_business_client.id
    assert_response :success
  end

  test "should see edit_contact page" do
    get :edit_contact, business_client_id: current_business_client.id, id: current_taxman.id
    assert_response :success
  end

  private
  def current_business_client
    @business_client ||= business_clients(:fixture)
  end

  def current_taxman
    @taxman ||= taxmen(:fixture)
  end
end
