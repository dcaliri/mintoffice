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

    it "should renewal exist stylesheet" do
      BankTransaction.parse_stylesheet('./spec/fixtures/yesterday.xls')
      BankTransaction.parse_stylesheet('./spec/fixtures/today.xls')

      transaction = BankTransaction.last
      transaction.transacted_at.should == Time.zone.parse("2012-04-09(11:25:12)")
      transaction.out.should == 1790275
      transaction.note.should == "좋은곳"
      transaction.remain.should == 199238327

      BankTransaction.count.should == 11
    end
  end
end