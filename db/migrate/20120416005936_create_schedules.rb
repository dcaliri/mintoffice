class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :annual_pay_schedules do |t|
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
