class AddExpenseReportIdToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :expense_report_id, :integer
  end
end
