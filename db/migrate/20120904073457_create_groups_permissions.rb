class CreateGroupsPermissions < ActiveRecord::Migration
  def change
    create_table :groups_permissions do |t|
      t.integer :permission_id
      t.integer :group_id
    end
  end
end
