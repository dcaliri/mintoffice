class ChangeUserIdToHrinfoIdToExceptColumns < ActiveRecord::Migration
  def up
    add_column :except_columns, :hrinfo_id, :integer
    
    ExceptColumn.find_each do |except_column|
      hrinfo = Hrinfo.find_by_user_id(except_column.user_id)

      except_column.hrinfo_id = hrinfo.id
      except_column.save!
    end  

    remove_column :except_columns, :user_id
  end

  def down
    add_column :except_columns, :user_id, :integer

    ExceptColumn.find_each do |except_column|
      hrinfo = Hrinfo.find(except_column.hrinfo_id)

      except_column.user_id = hrinfo.user_id
      except_column.save!
    end  

    remove_column :except_columns, :hrinfo_id
  end
end
