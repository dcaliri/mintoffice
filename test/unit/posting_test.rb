# encoding: UTF-8
require 'test_helper'

class PostingTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      posted_at: "#{Time.zone.now}",
      description: "상세내용 기입 테스트",
      expense_report_id: 2
    }
  end

  test "Posting should create posting with valid attributes" do
    posting = Posting.new(@valid_attributes)
    assert posting.valid?
  end

end