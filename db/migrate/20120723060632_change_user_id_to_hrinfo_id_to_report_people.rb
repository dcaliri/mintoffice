class ChangeUserIdToHrinfoIdToReportPeople < ActiveRecord::Migration
  def up
    add_column :report_people, :hrinfo_id, :integer
    
    ReportPerson.find_each do |report_person|
      hrinfo = Hrinfo.find_by_user_id(report_person.user_id)
      if hrinfo
        report_person.hrinfo_id = hrinfo.id
        report_person.save!
      end
    end

    remove_column :report_people, :user_id
  end

  def down
    add_column :report_people, :user_id, :integer

    ReportPerson.find_each do |report_person|
      if report_person.hrinfo_id
        hrinfo = Hrinfo.find(report_person.hrinfo_id)

        report_person.user_id = hrinfo.user_id
        report_person.save!
      end
    end  

    remove_column :report_people, :hrinfo_id
  end
end
