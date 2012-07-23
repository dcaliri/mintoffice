class ChangeUserIdToHrinfoIdToChangeHistories < ActiveRecord::Migration
  def up
    add_column :change_histories, :hrinfo_id, :integer
    
    ChangeHistory.find_each do |change_history|
      hrinfo = Hrinfo.find_by_user_id(change_history.user_id)
      if hrinfo
        change_history.hrinfo_id = hrinfo.id
        change_history.save!
      end
    end

    remove_column :change_histories, :user_id
  end

  def down
    add_column :change_histories, :user_id, :integer

    ChangeHistory.find_each do |change_history|
      if change_history.hrinfo_id
        hrinfo = Hrinfo.find(change_history.hrinfo_id)

        change_history.user_id = hrinfo.user_id
        change_history.save!
      end
    end  

    remove_column :change_histories, :hrinfo_id
  end
end
