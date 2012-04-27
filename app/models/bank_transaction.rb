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

  def self.in
    where("\"in\" > 0")
  end

  def self.out
    where("\"out\" > 0")
  end

  def self.oldest_at
    resource = order('transacted_at DESC').last
    if resource && resource.transacted_at
      resource.transacted_at
    else
      Time.zone.now
    end
  end


  def self.group_by_note_and_in
    all.group_by{|transaction| transaction.note }.map do |note, transaction|
      {note: note, amount: transaction.sum{|p| p.in}}
    end
  end

  def self.group_by_note_and_out
    all.group_by{|transaction| transaction.note }.map do |note, transaction|
      {note: note, amount: transaction.sum{|p| p.out}}
    end
  end

  def transfer
    time_start = transacted_at - 1.minutes
    time_end = transacted_at + 1.minutes

    collection = BankTransfer.where("transfered_at BETWEEN ? AND ? AND money + transfer_fee = ?", time_start, time_end, out)
    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end