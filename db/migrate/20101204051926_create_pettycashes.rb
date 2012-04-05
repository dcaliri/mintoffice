class CreatePettycashes < ActiveRecord::Migration
  def self.up
    create_table :pettycashes do |t|
      t.datetime :transdate
      t.decimal :inmoney, :default => 0, :null => false
      t.decimal :outmoney, :default => 0, :null => false
      t.text :description
      t.integer :attachment_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pettycashes
  end
end
