class RenameProjectsUsersToProjectAssignInfos < ActiveRecord::Migration
  class ProjectsUsers < ActiveRecord::Base
  end
  class ProjectAssignInfo < ActiveRecord::Base
  end

  def change
    create_table :project_assign_infos do |t|
      t.references :user
      t.references :project
      t.timestamps
    end

    ProjectsUsers.all.each do |info|
      ProjectAssignInfo.create!(user_id: info.user_id, project_id: info.project_id)
    end
  end
end