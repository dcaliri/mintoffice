class RemoveUnusedInfomationOfContacts < ActiveRecord::Migration
  def up
    remove_column :employees, :firstname
    remove_column :employees, :lastname
    remove_column :employees, :position
    remove_column :employees, :department
  end

  def down
    add_column :employees, :firstname, :string
    add_column :employees, :lastname, :string
    add_column :employees, :position, :string
    add_column :employees, :department, :string
  end
end
