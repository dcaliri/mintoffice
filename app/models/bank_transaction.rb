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

  include ActiveRecord::Extensions::TextSearch

  attr_accessor :no_verify

  before_save :verify_with_prev_transaction, unless: :no_verify
  before_create :set_transact_order

  module ClassMethods
    def find_valid_transaction
      collection = self + [last]
      latest = nil

      collection.each do |transaction|
        unless latest
          latest = transaction
          next
        end

        return transaction unless latest.verify(transaction)
        latest = transaction
      end
      nil
    end

    def search(text)
      search_by_text(text)
    end
  end
  extend ClassMethods

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
      errors.add(:verify, I18n.t('models.bank_transaction.fail'))
      false
    end
  end

  def set_transact_order
    parent = bank_account.bank_transactions
    last_transaction = parent.order(:transact_order).last

    if last_transaction
      latest_order = last_transaction.transact_order + 1
    else
      latest_order = 0
    end

    self.transact_order = latest_order
  end

  ###### DECORATOR ###############
  def transacted_at_strftime
    transacted_at.strftime("%Y-%m-%d %H.%M") rescue ""
  end
  ################################

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

  ## Excel Parser ######################################
  include SpreadsheetParsable
  include SpreadsheetParsable::BankTransactions::Shinhan
  include SpreadsheetParsable::BankTransactions::Ibk
  include SpreadsheetParsable::BankTransactions::Nonghyup

  def self.revise_excel_data(params)
    unless params[:transacted_time].blank?
      seconds_of_today = (params[:transacted_time] * 24 * 60 * 60)
      params[:transacted_at] = Time.at(Time.parse(params[:transacted_at]) + seconds_of_today)
      params.delete(:transacted_time)
    end
  end

  def self.preview_stylesheet(account, type, upload)
    previews = super(type, upload) do |class_name, query, params|
                 revise_excel_data(params)
                 account.send(class_name.to_s.tableize).build(params)
               end

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

    result = [next_transaction_on_db] + previews + [previous_transaction_on_db]
    result.extend(ClassMethods)
    result
  end

  def self.create_with_stylesheet(account, type, name)
    super(type, name) do |class_name, query, params|
      revise_excel_data(params)

      collections = account.send(class_name.to_s.tableize).where(query)
      if collections.empty?
        resource = collections.build(params)
        resource.no_verify = true
        resource.save!
      else
        resource = collections.first
        resource.no_verify = true
        resource.update_attributes!(params)
      end
    end
  end
end