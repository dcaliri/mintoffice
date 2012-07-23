class ChangeUserIdToHrinfoIdToVacations < ActiveRecord::Migration
  def up
    add_column :vacations, :hrinfo_id, :integer
    
    Vacation.find_each do |vacation|
      hrinfo = Hrinfo.find_by_user_id(vacation.user_id)

      vacation.hrinfo_id = hrinfo.id
      vacation.save!
    end  

    remove_column :vacations, :user_id
  end

  def down
    add_column :vacations, :user_id, :integer

    Vacation.find_each do |vacation|
      hrinfo = Hrinfo.find(vacation.hrinfo_id)

      vacation.user_id = hrinfo.user_id
      vacation.save!
    end  

    remove_column :vacations, :hrinfo_id
  end
end
