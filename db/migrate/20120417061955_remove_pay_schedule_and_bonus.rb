class RemovePayScheduleAndBonus < ActiveRecord::Migration
  def self.up
    drop_table :pay_schedules
    drop_table :bonuses
  end

  def self.down
    create_table :bonuses do |t|
      t.date :given_at
      t.decimal :amount, default: 0
      t.text :note
      t.references :user
      t.timestamps
    end

    create_table :pay_schedules do |t|
      t.decimal :income
      (1..12).each do |i|
        t.integer Date::MONTHNAMES[i].to_sym, default: 0
      end
      t.date :started_at
      t.references :user
      t.timestamps
    end
  end
end
