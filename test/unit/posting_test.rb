# encoding: UTF-8
require 'test_helper'

class PostingTest < ActiveSupport::TestCase
  fixtures :postings
  fixtures :posting_items
  fixtures :expense_reports

  setup do
    @valid_attributes = {
      posted_at: "#{Time.zone.now}",
      description: "상세내용 기입 테스트",
      expense_report_id: 2
    }

    @credit_attributes = {
      posting_id: 1,
      ledger_account_id: 1,
      item_type: 0,
      amount: 50000
    }

    @debit_attributes = {
      posting_id: 1,
      ledger_account_id: 1,
      item_type: 1,
      amount: 40000
    }
  end

  test "Posting should create posting with valid attributes" do
    posting = Posting.new(@valid_attributes)
    assert posting.valid?
  end

  test "Posting check total amount" do
    Posting.destroy_all
    PostingItem.destroy_all

    expense_report = ExpenseReport.find(expense_reports(:bankTransfer))
    posting = expense_report.make_posting

    credit = PostingItem.new(@credit_attributes)    
    debit = PostingItem.new(@debit_attributes)

    assert posting.invalid?
  end

end