class ChangeUserIdToHrinfoIdToCommutes < ActiveRecord::Migration
  def up
    add_column :commutes, :hrinfo_id, :integer
    
    Commute.find_each do |commute|
      next unless commute.user_id
      user = User.find(commute.user_id)
      next unless user.hrinfo

      commute.hrinfo_id = user.hrinfo.id
    end  

    remove_column :commutes, :user_id
  end

  def down
    add_column :commutes, :user_id, :integer

    Commute.find_each do |commute|
      next unless commute.hrinfo_id
      hrinfo = Hrinfo.find(commute.hrinfo_id)
      next unless hrinfo.user
      commute.user_id = hrinfo.user.id
    end  

    remove_column :commutes, :hrinfo_id
  end
end
