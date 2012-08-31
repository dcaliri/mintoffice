# encoding: UTF-8

class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account
  has_many :expense_reports, as: :target

  self.per_page = 20

  DEFAULT_COLUMNS = [:bank_account_name,
                     :transfer_type,
                     :transfered_at_strftime,
                     :result,
                     :out_bank_account,
                     :in_bank_name,
                     :in_bank_account,
                     :money,
                     :transfer_fee,
                     :error_money,
                     :registered_at_strftime,
                     :error_code,
                     :transfer_note,
                     :incode,
                     :out_account_note,
                     :in_account_note,
                     :in_person_name,
                     :cms_code,
                     :currency_code]

  def self.default_columns
    DEFAULT_COLUMNS
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.include_column :bank_account_name
    config.except_column :bank_account_id
    config.period_subtitle :transfered_at
    config.krw [:money, :transfer_fee, :error_money]
  end

  include ActiveRecord::Extensions::TextSearch

  ###### DECORATOR ###############
  def transfered_at_strftime
    transfered_at.strftime("%Y-%m-%d %H.%M") rescue ""
  end
  def registered_at_strftime
    registered_at.strftime("%Y-%m-%d %H.%M") rescue ""
  end
  ################################

  def totalamount
    self.money
  end

  def remain_amount_for_expense_report
    self.totalamount - expense_reports.total_amount
  end

  def self.search(text)
    search_by_text(text)
  end

  def self.latest
    order("transfered_at DESC")
  end

  def bank_account_name
    bank_account.name_with_number
  end

  def transaction
    return nil if !transfered_at or !money or !transfer_fee
    time_start = transfered_at - 1.minutes
    time_end = transfered_at + 1.minutes

    collection = BankTransaction.where(transacted_at: (time_start..time_end), out: money + transfer_fee)

    unless collection.empty?
      collection.first
    else
      nil
    end
  end

  ## Excel Parser ######################################
  include SpreadsheetParsable
  include SpreadsheetParsable::BankTransfers::Shinhan
  include SpreadsheetParsable::BankTransfers::Ibk
  include SpreadsheetParsable::BankTransfers::Nonghyup

  def self.preview_stylesheet(type, upload)
    super(type, upload) do |class_name, query, params|
      accounts = BankAccount.where(:number => params[:out_bank_account])
      unless accounts.empty?
        accounts.first.send(class_name.to_s.tableize).build(params)
      end
    end
  end

  def self.create_with_stylesheet(type, name)
    super(type, name) do |class_name, query, params|
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
  end
end