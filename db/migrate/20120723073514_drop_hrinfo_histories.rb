class DropHrinfoHistories < ActiveRecord::Migration
  def up
    drop_table :hrinfo_histories
  end

  def down
    create_table :hrinfo_histories do |t|
      t.integer :hrinfo_id
      t.string :change
      t.integer :user_id

      t.timestamps
    end
  end
end
