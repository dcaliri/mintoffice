# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  BANK_LIST = [
    ["일반 은행", :default],
    ["기업 은행", :ibk]
  ]

  DEFAULT = {
    :name => :default,
    :keys => {
      :transacted_at => :time,
      :in => :integer,
      :out => :integer,
      :remain => :integer
    },
    :columns => [
      :transacted_at,
      :transaction_type,
      :in,
      :out,
      :note,
      :remain,
      :branchname
    ],
    :position => {
      :start => {
        x: 2,
        y: 1
      },
      :end => 0
    }
  }
  IBK = {
    :name => :ibk,
    :keys => {
      :transacted_at => :time,
      :in => :integer,
      :out => :integer,
      :remain => :integer
    },
    :columns => [:transacted_at, :in, :out, :remain, :note],
    :position => {
      :start => {
        x: 8,
        y: 2
      },
      :end => 0
    }
  }

  set_parser_options DEFAULT
  set_parser_options IBK

  def self.latest
    order("transacted_at DESC")
  end

  def transfer
    collection = BankTransfer.where("transfered_at = ? AND money + transfer_fee = ?", transacted_at, out)
    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end