class ChangeUserIdToHrinfoIdToCommutes < ActiveRecord::Migration
  def up
    add_column :commutes, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE commutes
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = commutes.user_id)
    SQL

    remove_column :commutes, :user_id
  end

  def down
    add_column :commutes, :user_id, :integer

    execute <<-SQL
      UPDATE commutes
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = commutes.hrinfo_id)
    SQL

    remove_column :commutes, :hrinfo_id
  end
end
