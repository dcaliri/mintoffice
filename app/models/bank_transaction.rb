# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

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

  include StylesheetParsable

  def self.excel_parser(type)
    parser = ExcelParser.new
    parser.class_name BankTransaction
    if type == :shinhan
      parser.column SHINHAN[:columns]
      parser.key SHINHAN[:keys]
      parser.option :position => SHINHAN[:position]
    else
      parser.column IBK[:columns]
      parser.key IBK[:keys]
      parser.option :position => IBK[:position]
    end
    parser
  end

  def self.preview_stylesheet(type, upload)
    path = file_path(upload['file'].original_filename)
    parser = excel_parser(type.to_sym)

    create_file(path, upload['file'])
    parser.preview(path)
  end

  def self.create_with_stylesheet(account, type, name)
    path = file_path(name)
    parser = excel_parser(type.to_sym)

    parser.parse(path) do |class_name, query, params|
      collections = account.send(class_name.to_s.tableize).where(query)
      if collections.empty?
        collections.create!(params)
      else
        resource = collections.first
        resource.update_attributes!(params)
      end
    end
    File.delete(path)
  end

  def self.latest
    order("transacted_at DESC")
  end

  def self.in
    where("\"in\" > 0")
  end

  def self.out
    where("\"out\" > 0")
  end

  def self.total_in
    sum {|transaction| transaction.in }
  end

  def self.total_out
    sum {|transaction| transaction.out }
  end

  def self.margin
    total_in - total_out
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