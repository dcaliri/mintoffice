class MigrationDocumentTagsToEmployees < ActiveRecord::Migration
  def up
    Employee.find_each do |employee|
      documents = Tag.related_documents(employee.person.account.name, Employee.model_name.human)
      documents.delete(nil)
      documents.each do |document|
        document.update_column(:employee_id, employee.id)
      end
    end
  end

  def down
    Employee.find_each do |employee|
      documents = Tag.related_documents(employee.person.account.name, Employee.model_name.human)
      documents.delete(nil)
      documents.each do |document|
        document.update_column(:employee_id, nil)
      end
    end
  end
end
