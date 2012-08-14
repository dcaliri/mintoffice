class ChangeUserIdToHrinfoIdToAccessPerson < ActiveRecord::Migration
  def up
    add_column :access_people, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE access_people
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = access_people.user_id)
    SQL

    remove_column :access_people, :user_id
  end

  def down
    add_column :access_people, :user_id, :integer

    execute <<-SQL
      UPDATE access_people
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = access_people.hrinfo_id)
    SQL

    remove_column :access_people, :hrinfo_id
  end
end
