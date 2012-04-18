class CreateUsedVacations < ActiveRecord::Migration
  def change
    create_table :used_vacations do |t|
      t.references :user
      t.date :from
      t.date :to
      t.text :note
      t.boolean :approve
      t.timestamps
    end
  end
end
