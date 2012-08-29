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
    # config.include_column :bank_account_name
    # config.except_column :bank_account_id
    # config.except_column :out_bank_account
    # config.except_column :out_bank_name
    # config.except_column :promissory_check_amount
    # config.period_subtitle :transacted_at
  end
end