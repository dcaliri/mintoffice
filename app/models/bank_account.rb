# encoding: UTF-8

class BankAccount < ActiveRecord::Base
  has_many :bank_transactions, :dependent => :destroy
  has_many :bank_transfers, :dependent => :destroy
  has_many :creditcards

  include Historiable
  include Attachmentable
  include Reportable

  BANK_LIST = [
    [I18n.t('models.bank_account.shinhan'), :shinhan],
    [I18n.t('models.bank_account.ibk'), :ibk],
    [I18n.t('models.bank_account.hsbc'), :hsbc],
    [I18n.t('models.bank_account.nonghyup'), :nonghyup],
  ]

  def name
    value = read_attribute(:name)
    if value
      bank = BANK_LIST.find {|bank_info| bank_info[1] == value.to_sym}
      bank.present? ? bank[0] : value
    end
  end

  def name_
    read_attribute(:name)
  end

  def name_with_number
    name + " : " + number rescue ""
  end

  def description
    if number.nil? || note.nil?
      name
    else
      "#{name}-#{number}-#{note}"
    end
  end

  def remain
    unless bank_transactions.empty?
      bank_transactions.latest.first.remain
    else
      0
    end
  end

  class << self
    def remain
      sum(&:remain)
    end

    def transaction_per_period(query)
      collection = BankTransaction.where('transacted_at IS NOT NULL').order(query)
      if collection.empty?
        Time.zone.now
      else
        collection.first.transacted_at
      end
    end

    def newest_transaction
      transaction_per_period('transacted_at DESC')
    end

    def oldest_transaction
      transaction_per_period('transacted_at ASC') - 1.month
    end
  end
end