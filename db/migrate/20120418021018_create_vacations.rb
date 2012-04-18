class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.references :user
      t.date :from
      t.date :to
      t.decimal :period
      t.timestamps
    end

    rename_column :used_vacations, :user_id, :vacation_id
  end
end
