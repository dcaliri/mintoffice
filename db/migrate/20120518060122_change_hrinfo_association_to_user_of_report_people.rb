class ChangeHrinfoAssociationToUserOfReportPeople < ActiveRecord::Migration
  def up
    rename_column :report_people, :hrinfo_id, :user_id
    ReportPerson.find_each do |person|
      person.user_id = Hrinfo.find(person.user_id).user.id
      person.save!
    end
  end

  def down
    ReportPerson.find_each do |person|
      person.user_id = User.find(person.user_id).hrinfo.id
      person.save!
    end
    rename_column :report_people, :user_id, :hrinfo_id
  end
end
