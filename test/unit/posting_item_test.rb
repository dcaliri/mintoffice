# encoding: UTF-8
require 'test_helper'

class PostingItemTest < ActiveSupport::TestCase
  fixtures :posting_items

  setup do
    @valid_attributes = {
      posting_id: 1,
      ledger_account_id: 1,
      item_type: 0,
      amount: 1000000
    }
  end

  test "PostingItem should create posting_item with valid attributes" do
    posting_item = PostingItem.new(@valid_attributes)
    assert posting_item.valid?
  end

  test "PostingItem shouldn't create posting_item with invalid attributes" do
    posting_item = PostingItem.new(@valid_attributes)
    posting_item.ledger_account_id = nil
    assert posting_item.invalid?
  end
end