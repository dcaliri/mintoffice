class ChangeUserIdToHrinfoIdToVacations < ActiveRecord::Migration
  def up
    add_column :vacations, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE vacations
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = vacations.user_id)
    SQL

    remove_column :vacations, :user_id
  end

  def down
    add_column :vacations, :user_id, :integer

    execute <<-SQL
      UPDATE vacations
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = vacations.hrinfo_id)
    SQL

    remove_column :vacations, :hrinfo_id
  end
end
