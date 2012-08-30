class AssiciateEmployeesAndDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :employee_id, :integer
  end
end
