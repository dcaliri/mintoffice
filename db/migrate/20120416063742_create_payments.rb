class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date       :pay_at
      t.decimal    :amount, :default => 0.0
      t.text       :note
      t.references :user
      t.timestamps
    end
  end
end
