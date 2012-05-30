class RemoveApprovedToUsedVacation < ActiveRecord::Migration
  def up
    remove_column :used_vacations, :approve
  end

  def down
    add_column :used_vacations, :approve, :boolean
  end
end
