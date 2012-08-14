class RenameHrinfoIdToEmployeeId < ActiveRecord::Migration
  def up
    remove_index :employees, name: 'index_hrinfos_on_companyno'
    add_index :employees, :companyno

    remove_index :groups_hrinfos, name: 'index_groups_hrinfos_on_group_id_and_hrinfo_id'
    rename_table :groups_hrinfos, :employees_groups

    remove_index :hrinfos_permissions, name: 'index_hrinfos_permissions_on_permission_id_and_hrinfo_id'
    rename_table :hrinfos_permissions, :employees_permissions

    tables = [
      :attachments, 
      :change_histories, 
      :commutes, 
      :document_owners, 
      :except_columns, 
      :employees_groups, 
      :employees_permissions, 
      :payments, 
      :payrolls, 
      :project_assign_infos, 
      :vacations
    ]

    tables.each do |table|
      rename_column table, :hrinfo_id, :employee_id
    end

    add_index :employees_groups, [:group_id, :employee_id]
    add_index :employees_permissions, [:permission_id, :employee_id]
  end

  def down
    remove_index :employees_groups, name: 'index_employees_groups_on_group_id_and_employee_id'
    remove_index :employees_permissions, name: 'index_employees_permissions_on_permission_id_and_employee_id'

    tables = [
      :attachments, 
      :change_histories, 
      :commutes, 
      :document_owners, 
      :except_columns, 
      :employees_groups, 
      :employees_permissions, 
      :payments, 
      :payrolls, 
      :project_assign_infos, 
      :vacations
    ]

    tables.each do |table|
      rename_column table, :employee_id, :hrinfo_id
    end

    ###

    rename_table :employees_permissions, :hrinfos_permissions
    add_index :hrinfos_permissions, [:permission_id, :hrinfo_id]

    rename_table :employees_groups, :groups_hrinfos
    add_index :groups_hrinfos, [:group_id, :hrinfo_id]

    remove_index :employees, name: 'index_employees_on_companyno'
    add_index :employees, :companyno, name: 'index_hrinfos_on_companyno'
  end
end
