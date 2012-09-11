class ChangePeriodOfVacations < ActiveRecord::Migration
  def up
    change_column :vacations, :period, :decimal, precision: 10, scale: 1
    change_column :used_vacations, :period, :decimal, precision: 10, scale: 1
  end

  def down
    up
  end
end
