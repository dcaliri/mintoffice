class AddPeriodOfUsedVacations < ActiveRecord::Migration
  def change
    add_column :used_vacations, :period, :decimal
  end
end
