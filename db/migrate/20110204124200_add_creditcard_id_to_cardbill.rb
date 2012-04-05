class AddCreditcardIdToCardbill < ActiveRecord::Migration
  def self.up
    add_column :cardbills, :creditcard_id, :integer
  end

  def self.down
    remove_column :cardbills, :creditcard_id
  end
end