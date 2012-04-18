class CreateCommutes < ActiveRecord::Migration
  def change
    create_table :commutes do |t|
      t.datetime :go
      t.datetime :leave
      t.references :user
      t.timestamps
    end
  end
end
