# encoding: UTF-8

class PaymentRequest < ActiveRecord::Base
  belongs_to :basis, polymorphic: true

  DEFAULT_COLUMNS = [:bank_name,
                     :account_number,
                     :account_holder,
                     :amount
                     ]
  def self.default_columns
    DEFAULT_COLUMNS
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.krw [:amount]
  end

  def request_status
    self.complete ? "완료" : "미완료"
  end

  def complete!
    self.update_column(:complete, true)
  end

  def bank_transaction
    BankTransaction.where(out_bank_account: account_number, out: amount).first
  end

  def self.generate_payment_request(basis, amount)
    bankbook = basis.bankbook
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
end