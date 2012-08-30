class ModifyEmployeeIdOfProjectAssignInfosToPolymorphic < ActiveRecord::Migration
  def change
    add_column :project_assign_infos, :participant_type, :string
    rename_column :project_assign_infos, :employee_id, :participant_id

    execute <<-SQL
      UPDATE `project_assign_infos`
      SET `participant_type` = "Employee"
    SQL
  end
end
