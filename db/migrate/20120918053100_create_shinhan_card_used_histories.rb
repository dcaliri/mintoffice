class CreateShinhanCardUsedHistories < ActiveRecord::Migration
  def change
    create_table :shinhan_card_used_histories do |t|
      t.string   :card_no
      t.string   :bank_account
      t.string   :bank_name
      t.string   :card_holder_name
      t.string   :used_area
      t.string   :approve_no
      t.datetime :approved_at
      t.datetime :approved_time
      t.string   :sales_type
      t.decimal  :money_krw,             :precision => 10, :scale => 2
      t.decimal  :money_foreign,         :precision => 10, :scale => 2
      t.decimal  :price,                 :precision => 10, :scale => 2
      t.decimal  :tax,                   :precision => 10, :scale => 2
      t.decimal  :tip,                   :precision => 10, :scale => 2
      t.string   :monthly_duration
      t.string   :exchange_krw
      t.string   :foreign_country_code
      t.string   :foreign_country_name
      t.string   :store_business_no
      t.string   :store_name
      t.string   :store_type
      t.string   :store_zipcode
      t.string   :store_addr1
      t.string   :store_addr2
      t.string   :store_tel
    end
  end
end
