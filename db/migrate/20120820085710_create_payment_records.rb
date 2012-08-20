class CreatePaymentRecords < ActiveRecord::Migration
  def change
    create_table :payment_records do |t|
      t.string :name
      t.timestamps
    end
  end
end
