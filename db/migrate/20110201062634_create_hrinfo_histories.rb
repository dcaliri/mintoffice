class CreateHrinfoHistories < ActiveRecord::Migration
  def self.up
    create_table :hrinfo_histories do |t|
      t.integer :hrinfo_id
      t.string :change
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :hrinfo_histories
  end
end
