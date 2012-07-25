class RenameHrinfoIdToEmployeeIdOfExpenseReports < ActiveRecord::Migration
  def change
  	rename_column :expense_reports, :hrinfo_id, :employee_id
  end
end
