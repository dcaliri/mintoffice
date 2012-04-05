class CreateCardbills < ActiveRecord::Migration
  def self.up
    create_table :cardbills do |t|
      t.string :cardno
      t.datetime :transdate
      t.decimal :amount
      t.decimal :vat
      t.decimal :servicecharge
      t.decimal :totalamount
      t.string :storename
      t.string :storeaddr
      t.string :approveno

      t.timestamps
    end
  end

  def self.down
    drop_table :cardbills
  end
end
