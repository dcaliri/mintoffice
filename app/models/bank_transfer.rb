# encoding: UTF-8

class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account
  has_one :expense_report, as: :target

  self.per_page = 20

  BANK_LIST = [
    ["신한 은행", :shinhan],
    ["기업 은행", :ibk]
  ]


  SHINHAN = {
    :name => :shinhan,
    :keys => {
      :transfer_type => :integer,
      :transfered_at => :time,
    },
    :columns => [
      :transfer_type,
      :transfered_at,
      :result,
      :out_bank_account,
      :in_bank_name,
      :in_bank_account,
      :money,
      :transfer_fee,
      :error_money,
      :registered_at,
      :error_code,
      :transfer_note,
      :incode,
      :out_account_note,
      :in_account_note,
      :in_person_name
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
      :transfer_type => :integer,
      :transfered_at => :time,
    },
    :columns => [
      :transfer_type,
      :transfered_at,
      :transfered_at,
      :result,
      :out_bank_account,
      :money,
      :transfer_fee,
      :in_bank_name,
      :in_bank_account,
      :out_account_note,
      :in_account_note,
      :in_person_name,
      :cms_code,
      :currency_code
    ],
    :position => {
      :start => {
        x: 7,
        y: 2
      },
      :end => -1
    }
  }

  include StylesheetParsable

  def self.excel_parser(type)
    parser = ExcelParser.new
    parser.class_name BankTransfer
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
    previews = []
    parser.parse(path) do |class_name, query, params|
      accounts = BankAccount.where(:number => params[:out_bank_account])
      unless accounts.empty?
        previews << accounts.first.send(class_name.to_s.tableize).build(params)
      end
    end
    previews
  end

  def self.create_with_stylesheet(type, name)
    path = file_path(name)
    parser = excel_parser(type.to_sym)

    parser.parse(path) do |class_name, query, params|
      accounts = BankAccount.where(:number => params[:out_bank_account])

      unless accounts.empty?
        account = accounts.first
        collections = account.send(class_name.to_s.tableize).where(query)
        if collections.empty?
          collections.create!(params)
        else
          resource = collections.first
          resource.update_attributes!(params)
        end
      end
    end
    File.delete(path)
  end

  def self.latest
    order("transfered_at DESC")
  end

  def transaction
    time_start = transfered_at - 1.minutes
    time_end = transfered_at + 1.minutes

    collection = BankTransaction.where(transacted_at: (time_start..time_end), out: money + transfer_fee)

    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end