class RemoveUnusedColumnOfCardbills < ActiveRecord::Migration
  def add
    remove_column :cardbills, :servicecharge
    remove_column :cardbills, :vat
    remove_column :cardbills, :storeaddr
  end

  def remove
    add_column :cardbills, :servicecharge, :integer
    add_column :cardbills, :vat, :integer
    add_column :cardbills, :storeaddr, :string
  end

end
