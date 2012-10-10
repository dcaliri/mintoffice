# encoding: UTF-8

class PaymentRequest < ActiveRecord::Base
  belongs_to :basis, polymorphic: true, counter_cache: true

  DEFAULT_COLUMNS = [:bankbook_code,
                     :account_number_for_excel,
                     :amount_for_excel,
                     :deposit_info,
                     :withdraw_info
                     ]
  def self.default_columns
    DEFAULT_COLUMNS
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.no_header
    config.krw [:amount]
  end

  def bankbook_code
    bankbook = basis.bankbook rescue nil
    bankbook.bank_code.to_s.rjust(3, '0') if bankbook
  end

  def account_number_for_excel
    account_number.gsub(/[^0-9]/, '') rescue ""
  end

  def amount_for_excel
    amount.to_i.to_s
  end

  def deposit_info
    account_holder
  end

  def withdraw_info
    Company.current_company.name
  end

  def bankbook_name
    bankbook = basis.bankbook rescue nil
    bankbook.name if bankbook
  end

  def request_status
    self.complete ? "지급 완료" : "청구후 지급전"
  end

  def complete!
    self.update_column(:complete, true)
  end

  def bank_transaction
    BankTransaction.where(out_bank_account: account_number, out: amount).first
  end

  class << self
    def complete(status)
      where(complete: status)
    end

    def generate_payment_request(basis, bankbook, amount)
      new do |request|
        if bankbook
          request.bank_name = bankbook.bankname
          request.account_number = bankbook.number
          request.account_holder = bankbook.account_holder
        end

        request.amount = amount
        request.basis = basis
      end
    end

    def complete!
      self.update_all(complete: true)
    end

  end
end