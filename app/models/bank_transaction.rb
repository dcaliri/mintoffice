# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  include StylesheetParseable

  BANK_LIST = [
    ["신한 은행", :shinhan],
    ["기업 은행", :ibk]
  ]

  SHINHAN = {
    :name => :shinhan,
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
    :columns => [
      :transacted_at,
      :out,
      :in,
      :remain,
      :note,
      :out_bank_account,
      :out_bank_name,
      :transaction_type,
      :promissory_check_amount,
      :cms_code
    ],
    :position => {
      :start => {
        x: 8,
        y: 2
      },
      :end => -1
    }
  }

  set_parser_options SHINHAN
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