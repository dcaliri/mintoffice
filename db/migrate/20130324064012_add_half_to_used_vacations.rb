class AddHalfToUsedVacations < ActiveRecord::Migration
  def change
  	add_column :used_vacations, :from_half, :string
  	add_column :used_vacations, :to_half, :string
  end
end
