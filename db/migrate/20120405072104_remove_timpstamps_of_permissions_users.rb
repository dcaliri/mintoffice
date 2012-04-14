class RemoveTimpstampsOfPermissionsUsers < ActiveRecord::Migration
  def change
    remove_index :permissions_users, [:permission_id, :user_id]
    remove_column :permissions_users, :created_at
    remove_column :permissions_users, :updated_at
    add_index :permissions_users, [:permission_id, :user_id], :unique => true
  end
end
