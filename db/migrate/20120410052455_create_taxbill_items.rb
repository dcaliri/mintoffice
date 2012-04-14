class CreateTaxbillItems < ActiveRecord::Migration
  def change
    create_table :taxbill_items do |t|
      t.datetime :transacted_at
      t.text :note
      t.decimal :unitprice, :default => 0, :null => false
      t.integer :quantity
      t.decimal :price, :default => 0, :null => false
      t.decimal :tax, :default => 0, :null => false
      t.decimal :sumvalue, :default => 0, :null => false
      t.references :taxbill
      t.timestamps
    end
  end

end