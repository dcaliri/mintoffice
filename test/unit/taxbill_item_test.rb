# encoding: UTF-8
require 'test_helper'

class TaxbillItemTest < ActiveSupport::TestCase
  fixtures :taxbill_items

  setup do
    @valid_attributes = {
      transacted_at: "#{Time.zone.now}",
      note: "테스트 매입 노트",
      unitprice: 6500,
      quantity: 55,
      total: 393250,
      tax: 35750,
      taxbill_id: 1
    }
  end

  test "TaxbillItem should create taxbill_item with valid attributes" do
    taxbill_item = TaxbillItem.new(@valid_attributes)
    assert taxbill_item.valid?
  end

  test "TaxbillItem shouldn't create taxbill_item with invalid attributes" do
    taxbill_item = TaxbillItem.new(@valid_attributes)
    taxbill_item.quantity = "test"
    assert taxbill_item.invalid?

    taxbill_item = TaxbillItem.new(@valid_attributes)
    taxbill_item.quantity = -1
    assert taxbill_item.invalid?
  end
end