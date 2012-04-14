class RemoveTimestampsOfGroupsUsers < ActiveRecord::Migration
  def change
    remove_column :groups_users, :created_at
    remove_column :groups_users, :updated_at
  end
end
