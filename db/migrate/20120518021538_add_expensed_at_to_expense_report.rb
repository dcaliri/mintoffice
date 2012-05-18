class AddExpensedAtToExpenseReport < ActiveRecord::Migration
  def change
    add_column :expense_reports, :expensed_at, :date
    ExpenseReport.update_all('expensed_at = created_at')
  end
end
