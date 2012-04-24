class CreateCardUsedSource < ActiveRecord::Migration
  def change
    create_table :card_used_sources do |t|
      t.references :creditcard
      t.string :card_no
      t.string :bank_account
      t.string :bank_name
      t.string :card_holder_name
      t.string :used_area
      t.string :approve_no
      t.datetime :approved_at
      t.datetime :approved_time
      t.string :sales_type
      t.integer :money_krw
      t.integer :money_foreign
      t.integer :price
      t.integer :tax
      t.integer :tip
      t.string :monthly_duration
      t.string :exchange_krw
      t.string :foreign_country_code
      t.string :foreign_country_name
      t.string :store_business_no
      t.string :store_name
      t.string :store_type
      t.string :store_zipcode
      t.string :store_addr1
      t.string :store_addr2
      t.string :store_tel
    end
  end
end
