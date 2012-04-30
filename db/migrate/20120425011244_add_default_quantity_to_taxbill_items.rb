class AddDefaultQuantityToTaxbillItems < ActiveRecord::Migration
  def self.up
    change_column :taxbill_items, :quantity, :integer, :default => 1
  end

  def self.down
    change_column :taxbill_items, :quantity, :integer
  end
end
