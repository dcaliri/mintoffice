class ChangeEmployeesPermissions < ActiveRecord::Migration
  def up
  	remove_index :employees_permissions, name: 'index_employees_permissions_on_permission_id_and_employee_id'

  	rename_column :employees_permissions, :employee_id, :person_id
  	rename_table  :employees_permissions, :people_permissions

  	add_index	:people_permissions, [:person_id, :permission_id]
  end

  def down
  	remove_index :people_permissions, name: 'index_people_permissions_on_person_id_and_permission_id'

  	rename_column :people_permissions, :person_id, :employee_id
  	rename_table  :people_permissions, :employees_permissions

  	add_index	:employees_permissions, [:permission_id, :employee_id]
  end
end
