# encoding: UTF-8

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

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

  include SpreadsheetParsable
  include Excels::BankTransactions::Shinhan
  include Excels::BankTransactions::Ibk

  include ResourceExportable
  resource_exportable_configure do |config|
    config.krw [:in, :out, :remain]
    config.include_column :bank_account_name
    config.except_column :bank_account_id
    config.except_column :out_bank_account
    config.except_column :out_bank_name
    config.except_column :promissory_check_amount
    config.period_subtitle :transacted_at
  end

  before_save :verify_with_prev_transaction
  before_save :set_transact_order, on: :create

  def verify_with_prev_transaction
    parent = bank_account.bank_transactions
    if id
      prev = parent.where("transacted_at <= ?", transacted_at).order(:transacted_at).last
    else
      prev = parent.order(:transacted_at).last
    end

    if verify(prev)
      true
    else
      errors.add(:verify, '에 실패했습니다. 입력 값을 다시 확인해주세요')
      false
    end
  end

  def set_transact_order
    parent = bank_account.bank_transactions
    latest_order = (parent.order(:transact_order).last.transact_order + 1 rescue 0)
    self.transact_order = latest_order
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

    old_transaction = previews[-1]
    new_transaction = previews[0]

    bank_transactions = account.bank_transactions
    if old_transaction
      transacted_at = old_transaction.transacted_at
      previous_transaction_on_db = bank_transactions.where("transacted_at < ?", transacted_at).order(:transacted_at).last
    end

    if new_transaction
      transacted_at = new_transaction.transacted_at
      next_transaction_on_db = bank_transactions.where("transacted_at > ?", transacted_at).order(:transacted_at).first
    end

    [next_transaction_on_db] + previews + [previous_transaction_on_db]
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
    return true if !transaction or self == transaction
    self.before_remain == transaction.remain
  end

  [:in, :out].each do |accessor|
    define_method accessor do
      read_attribute(accessor) || 0
    end
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
    return nil unless transacted_at

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