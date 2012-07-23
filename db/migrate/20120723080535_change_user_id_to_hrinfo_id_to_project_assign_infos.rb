class ChangeUserIdToHrinfoIdToProjectAssignInfos < ActiveRecord::Migration
  def up
    add_column :project_assign_infos, :hrinfo_id, :integer
    
    ProjectAssignInfo.find_each do |assign_info|
      hrinfo = Hrinfo.find_by_user_id(assign_info.user_id)
      if hrinfo
        assign_info.hrinfo_id = hrinfo.id
        assign_info.save!
      end
    end

    remove_column :project_assign_infos, :user_id
  end

  def down
    add_column :project_assign_infos, :user_id, :integer

    ProjectAssignInfo.find_each do |assign_info|
      if assign_info.hrinfo_id
        hrinfo = Hrinfo.find(assign_info.hrinfo_id)

        assign_info.user_id = hrinfo.user_id
        assign_info.save!
      end
    end

    remove_column :project_assign_infos, :hrinfo_id
  end
end
