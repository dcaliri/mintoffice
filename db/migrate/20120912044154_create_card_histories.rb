class CreateCardHistories < ActiveRecord::Migration
  def change
    create_table :card_histories do |t|
      t.datetime :transacted_at
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :amount_local, precision: 10, scale: 2
      t.decimal :amount_dollar, precision: 10, scale: 2
      t.string :country
      t.string :store_name
      t.string :approved_status
      t.string :approved_number
      t.date :paid_at

      t.timestamps
    end
  end
end
