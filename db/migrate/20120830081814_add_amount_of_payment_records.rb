class AddAmountOfPaymentRecords < ActiveRecord::Migration
  def change
    add_column :payment_records, :amount, :decimal, default: 0
  end
end
