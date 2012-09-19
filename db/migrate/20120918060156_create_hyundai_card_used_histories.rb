class CreateHyundaiCardUsedHistories < ActiveRecord::Migration
  def change
    create_table :hyundai_card_used_histories do |t|
      t.date     :used_at
      t.string   :card_no
      t.string   :card_holder_name
      t.string   :store_name
      t.string   :tax_type
      t.decimal  :price,                 :precision => 10, :scale => 2
      t.string   :approve_no
      t.string   :sales_statement
      t.string   :nation_statement
      t.decimal  :money_krw,             :precision => 10, :scale => 2
      t.string   :exchange_krw
      t.string   :exchange_us
      t.string   :prepayment_statement
      t.date     :accepted_at
      t.date     :approved_at
      t.string   :apply_sales_statement
      t.string   :purchase_statement
    end
  end
end
