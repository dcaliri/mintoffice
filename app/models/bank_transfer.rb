# encoding: UTF-8

class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account

  self.per_page = 20

  include StylesheetParseable

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

  set_parser_options SHINHAN
  set_parser_options IBK

  def self.open_and_parse_stylesheet(account, upload, type)
    @account = account
    super(upload, type)
  end

  def self.preview_stylesheet(account, upload, type)
    @account = account
    super(upload, type)
  end

  def self.create_with_stylesheet(account, upload, type)
    @account = account
    super(upload, type)
  end

  def self.before_parser_filter(params)
    @account.number == params[:out_bank_account]
  end

  def self.latest
    order("transfered_at DESC")
  end

  def transaction
    collection = BankTransaction.where(transacted_at: transfered_at - transfered_at.sec, out: money + transfer_fee)
    unless collection.empty?
      collection.first
    else
      nil
    end
  end
end