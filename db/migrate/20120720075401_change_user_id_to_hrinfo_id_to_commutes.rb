class ChangeUserIdToHrinfoIdToCommutes < ActiveRecord::Migration
  def up
    add_column :commutes, :hrinfo_id, :integer
    
    Commute.find_each do |commute|
      hrinfo = Hrinfo.find_by_user_id(commute.user_id)

      commute.hrinfo_id = hrinfo.id
      commute.save!
    end  

    remove_column :commutes, :user_id
  end

  def down
    add_column :commutes, :user_id, :integer

    Commute.find_each do |commute|
      hrinfo = Hrinfo.find(commute.hrinfo_id)

      commute.user_id = hrinfo.user_id
      commute.save!
    end  

    remove_column :commutes, :hrinfo_id
  end
end
