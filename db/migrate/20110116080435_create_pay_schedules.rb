class CreatePaySchedules < ActiveRecord::Migration
  def self.up
    create_table :pay_schedules do |t|
      t.integer :user_id
      t.date :payday
      t.decimal :amount
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :pay_schedules
  end
end
