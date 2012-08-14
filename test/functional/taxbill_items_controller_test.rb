require 'test_helper'

class TaxbillItemsControllerTest < ActionController::TestCase
  fixtures :taxbills, :taxbill_items

  def setup
    current_user.permission.create!(name: 'taxbills')
  end

  test "should see new page" do
    get :new, taxbill_id: 1
    assert_response :success
  end

  test "should see edit page" do
    get :edit, taxbill_id: 1, :id => current_taxbill_item.id
    assert_response :success
  end

  private
  def current_taxbill_item
    @taxbill_item ||= taxbill_items(:fixture)
  end
end