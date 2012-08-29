# encoding: UTF-8

class PaymentRequest < ActiveRecord::Base

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
end