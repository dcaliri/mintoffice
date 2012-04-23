# encoding: UTF-8
require 'spec_helper'

describe StylesheetParseable do
  class BankTransaction < ActiveRecord::Base
    include StylesheetParseable

    DEFAULT = {
      :name => :default,
      :keys => {
        :transacted_at => :time,
        :in => :integer,
        :out => :integer,
      },
      :columns => [
        :transacted_at,
        :transaction_type,
        :in,
        :out,
        :note,
      ],
      :position => {
        :start => {
          x: 2,
          y: 1
        },
        :end => 0
      }
    }
    set_parser_options DEFAULT
  end

  describe "#parse_stylesheet" do
    it "should parse stylesheet file" do
      BankTransaction.parse_stylesheet('./spec/fixtures/stylesheets/test.xls')

      table = BankTransaction.first
      table.transacted_at.should == Time.zone.parse("2012-04-13(12:03:16)")
      table.in.should == 30360000
      table.out.should == 0
      BankTransaction.count.should == 10
    end

    it "should renewal exist stylesheet" do
      BankTransaction.parse_stylesheet('./spec/fixtures/stylesheets/yesterday.xls')
      BankTransaction.parse_stylesheet('./spec/fixtures/stylesheets/today.xls')

      transaction = BankTransaction.last
      transaction.transacted_at.should == Time.zone.parse("2012-04-09(11:25:12)")
      transaction.out.should == 1790275
      transaction.note.should == "좋은곳"

      BankTransaction.count.should == 11
    end
  end
end