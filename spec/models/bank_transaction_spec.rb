# encoding: UTF-8
require 'spec_helper'

describe BankTransaction do
  describe "#parse_stylesheet" do
    it "should parse stylesheet file" do
      BankTransaction.parse_stylesheet('./spec/fixtures/test.xls')

      transaction = BankTransaction.first
      transaction.transacted_at.should == Time.zone.parse("2012-04-13(12:03:16)")
      transaction.transaction_type.should == "e_만기"
      transaction.in.should == 30360000
      transaction.out.should == 0
      transaction.note.should == "엘지전자(주)"
      transaction.remain.should == 227599082
      transaction.branchname.should == "여중대"

      BankTransaction.count.should == 10
    end
  end
end