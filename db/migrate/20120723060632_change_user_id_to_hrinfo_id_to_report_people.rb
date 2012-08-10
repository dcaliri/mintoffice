class ChangeUserIdToHrinfoIdToReportPeople < ActiveRecord::Migration
  def up
    add_column :report_people, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE report_people
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = report_people.user_id)
    SQL

    remove_column :report_people, :user_id
  end

  def down
    add_column :report_people, :user_id, :integer

    execute <<-SQL
      UPDATE report_people
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = report_people.hrinfo_id)
    SQL
    
    remove_column :report_people, :hrinfo_id
  end
end
