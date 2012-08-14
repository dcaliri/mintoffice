class ChangeUserIdToHrinfoIdToPermissionsUsers < ActiveRecord::Migration
  def up
    remove_index :permissions_users, :name => "index_permissions_users_on_permission_id_and_user_id"
    add_column :permissions_users, :hrinfo_id, :integer

    execute <<-SQL
      UPDATE permissions_users
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = permissions_users.user_id)
    SQL

    remove_column :permissions_users, :user_id
    rename_table :permissions_users, :hrinfos_permissions
    add_index :hrinfos_permissions, [:permission_id, :hrinfo_id]
  end

  def down
    remove_index :hrinfos_permissions, :name => "index_hrinfos_permissions_on_permission_id_and_hrinfo_id"
    add_column :hrinfos_permissions, :user_id, :integer

    execute <<-SQL
      UPDATE hrinfos_permissions
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = hrinfos_permissions.hrinfo_id)
    SQL

    remove_column :hrinfos_permissions, :hrinfo_id
    rename_table :hrinfos_permissions, :permissions_users
    add_index :permissions_users, [:permission_id, :user_id]
  end
end
