class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.string :bank_name
      t.string :account_number
      t.string :account_holder
      t.decimal :amount
      t.string :request_status
      t.timestamps
    end
  end
end
