class ChangeUserIdToHrinfoIdToChangeHistories < ActiveRecord::Migration
  def up
    add_column :change_histories, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE change_histories
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = change_histories.user_id)
    SQL

    remove_column :change_histories, :user_id
  end

  def down
    add_column :change_histories, :user_id, :integer

    execute <<-SQL
      UPDATE change_histories
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = change_histories.hrinfo_id)
    SQL

    remove_column :change_histories, :hrinfo_id
  end
end
