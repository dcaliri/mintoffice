class ChangeUserIdToHrinfoIdToAccessPerson < ActiveRecord::Migration
  def up
    add_column :access_people, :hrinfo_id, :integer
    
    AccessPerson.find_each do |access_person|
      hrinfo = Hrinfo.find_by_user_id(access_person.user_id)
      if hrinfo
        access_person.hrinfo_id = hrinfo.id
        access_person.save!
      end
    end

    remove_column :access_people, :user_id
  end

  def down
    add_column :access_people, :user_id, :integer

    AccessPerson.find_each do |access_person|
      if access_person.hrinfo_id
        hrinfo = Hrinfo.find(access_person.hrinfo_id)

        access_person.user_id = hrinfo.user_id
        access_person.save!
      end
    end

    remove_column :access_people, :hrinfo_id
  end
end
