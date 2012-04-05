class CreateHrinfos < ActiveRecord::Migration
  def self.up
    create_table :hrinfos do |t|
      t.string :firstname
      t.string :lastname
      t.integer :picture_id

      t.timestamps
    end
  end

  def self.down
    drop_table :hrinfos
  end
end
