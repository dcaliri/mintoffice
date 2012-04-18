class ChangePaySchedules < ActiveRecord::Migration
  def self.up
    drop_table :pay_schedules
    rename_table :annual_pay_schedules, :pay_schedules
  end

  def self.down
    rename_table :pay_schedules, :annual_pay_schedules
    create_table :pay_schedules do |t|
      t.integer :user_id
      t.date :payday
      t.decimal :amount
      t.string :category

      t.timestamps
    end
  end
end
