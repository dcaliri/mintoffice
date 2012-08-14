class ChangeUserIdToHrinfoIdToGroupsUsers < ActiveRecord::Migration
  def up
    add_column :groups_users, :hrinfo_id, :integer

    execute <<-SQL
      UPDATE groups_users
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = groups_users.user_id)
    SQL

    remove_column :groups_users, :user_id
    rename_table :groups_users, :groups_hrinfos
    add_index :groups_hrinfos, [:group_id, :hrinfo_id]
  end

  def down
    remove_index :groups_hrinfos, :name => "index_groups_hrinfos_on_group_id_and_hrinfo_id"
    add_column :groups_hrinfos, :user_id, :integer

    execute <<-SQL
      UPDATE groups_hrinfos
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = groups_hrinfos.hrinfo_id)
    SQL

    remove_column :groups_hrinfos, :hrinfo_id
    rename_table :groups_hrinfos, :groups_users
  end
end
