class RemoveSumvalueOfTaxbillItem < ActiveRecord::Migration
  def change
    remove_column :taxbill_items, :sumvalue
  end
end
