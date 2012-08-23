require 'test_helper'

class TaxbillItemsControllerTest < ActionController::TestCase
  fixtures :taxbills, :taxbill_items

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
    @taxbill_item ||= taxbill_items(:purchase_item)
  end
end
