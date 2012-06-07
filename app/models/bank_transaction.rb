# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  BANK_LIST = [
    ["신한 은행", :shinhan],
    ["기업 은행", :ibk]
  ]

  DEFAULT_COLUMNS = [:bank_account_name,
                     :transacted_at_strftime,
                     :transaction_type,
                     :in,
                     :out,
                     :note,
                     :remain,
                     :branchname,
                     :out_bank_account,
                     :out_bank_name,
                     :promissory_check_amount,
                     :cms_code
                     ]

  def self.default_columns
    DEFAULT_COLUMNS
  end

  include StylesheetParsable
  include Excels::BankTransactions::Shinhan
  include Excels::BankTransactions::Ibk

  include ResourceExportable
  resource_exportable_configure do |config|
    config.money [3, 4, 6]
    config.include_column :bank_account_name
    config.except_column :bank_account_id
    config.except_column :out_bank_account
    config.except_column :out_bank_name
    config.except_column :promissory_check_amount
    config.period_subtitle :transacted_at
  end

  def self.excel_parser(type)
    if type == :shinhan
      shinhan_bank_transaction_parser
    else
      ibk_bank_transaction_parser
    end
  end

  ###### DECORATOR ###############
  def transacted_at_strftime
    transacted_at.strftime("%Y-%m-%d %H.%M") rescue ""
  end
  ################################


  def self.preview_stylesheet(account, type, upload)
    raise ArgumentError, I18n.t('common.upload.empty') unless upload
    path = file_path(upload['file'].original_filename)
    parser = excel_parser(type.to_sym)

    create_file(path, upload['file'])
    previews = []
    parser.parse(path) {|class_name, query, params| previews << account.send(class_name.to_s.tableize).build(params)}
    previews
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

  def bank_account_name
    bank_account.name_with_number
  end

  def verify(transaction)
    return true if self == transaction
    self.before_remain == transaction.remain
  end

  def before_remain
    self.remain + self.out - self.in
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