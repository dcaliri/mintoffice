class AddOwnerOfProjectAssignInfos < ActiveRecord::Migration
  def change
    add_column :project_assign_infos, :owner, :boolean, default: false
  end
end
