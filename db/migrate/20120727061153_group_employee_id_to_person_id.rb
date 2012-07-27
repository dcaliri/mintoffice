class GroupEmployeeIdToPersonId < ActiveRecord::Migration
  def up
  	remove_index	:employees_groups, name: "index_employees_groups_on_group_id_and_employee_id"

  	rename_column :employees_groups, :employee_id, :person_id
  	rename_table  :employees_groups, :groups_people

  	add_index			:groups_people, [:person_id, :group_id]
  end

  def down
  	remove_index	:groups_people, name: "index_groups_people_on_person_id_and_group_id"

		rename_column :groups_people, :person_id, :employee_id
		rename_table  :groups_people, :employees_groups

		add_index			:employees_groups, [:group_id, :employee_id]
  end
end
