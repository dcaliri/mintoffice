# encoding: UTF-8

class BankTransfer < ActiveRecord::Base
  belongs_to :bank_account
  has_one :expense_report, as: :target

  self.per_page = 20

  BANK_LIST = [
    ["신한 은행", :shinhan],
    ["기업 은행", :ibk]
  ]

  include StylesheetParsable
  include Excels::BankTransfers::Shinhan
  include Excels::BankTransfers::Ibk

  include ResourceExportable
  resource_exportable_configure do |config|
    config.include_column 'bank_account_name'
    config.except_column 'bank_account_id'
    config.period_subtitle :transfered_at
  end

  def self.excel_parser(type)
    if type == :shinhan
      shinhan_bank_transfer_parser
    else
      ibk_bank_transfer_parser
    end
  end

  def self.preview_stylesheet(type, upload)
    raise ArgumentError, I18n.t('common.upload.empty') unless upload
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

  def bank_account_name
    bank_account.name_with_number
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