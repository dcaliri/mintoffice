class AddDeductibleToVacationTypes < ActiveRecord::Migration
  def change
    add_column :vacation_types, :deductible, :boolean
  end
end
