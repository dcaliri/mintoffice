class ChangePriceColumnToTotal < ActiveRecord::Migration
  def change
    rename_column :taxbill_items, :price, :total
  end
end
