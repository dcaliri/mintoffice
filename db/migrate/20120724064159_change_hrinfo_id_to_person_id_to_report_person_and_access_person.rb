class ChangeHrinfoIdToPersonIdToReportPersonAndAccessPerson < ActiveRecord::Migration
  def up
    add_column :report_people, :person_id, :integer
    add_column :access_people, :person_id, :integer

    execute <<-SQL
      UPDATE report_people
      SET person_id = (SELECT hrinfos.person_id
      FROM hrinfos
      WHERE hrinfos.id = report_people.hrinfo_id)
    SQL

    execute <<-SQL
      UPDATE access_people
      SET person_id = (SELECT hrinfos.person_id
      FROM hrinfos
      WHERE hrinfos.id = access_people.hrinfo_id)
    SQL

    remove_column :report_people, :hrinfo_id
    remove_column :access_people, :hrinfo_id
  end

  def down
    add_column :access_people, :hrinfo_id, :integer
    add_column :report_people, :hrinfo_id, :integer

    execute <<-SQL
      UPDATE access_people
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.person_id = access_people.person_id)
    SQL

    execute <<-SQL
      UPDATE report_people
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.person_id = report_people.person_id)
    SQL

    remove_column :access_people, :person_id
    remove_column :report_people, :person_id
  end
end
