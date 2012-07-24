class ChangeUserIdToHrinfoIdToProjectAssignInfos < ActiveRecord::Migration
  def up
    add_column :project_assign_infos, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE project_assign_infos
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = project_assign_infos.user_id)
    SQL

    remove_column :project_assign_infos, :user_id
  end

  def down
    add_column :project_assign_infos, :user_id, :integer

    execute <<-SQL
      UPDATE project_assign_infos
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = project_assign_infos.hrinfo_id)
    SQL
    
    remove_column :project_assign_infos, :hrinfo_id
  end
end
