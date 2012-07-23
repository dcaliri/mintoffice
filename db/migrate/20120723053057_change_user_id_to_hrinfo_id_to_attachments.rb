class ChangeUserIdToHrinfoIdToAttachments < ActiveRecord::Migration
  def up
    add_column :attachments, :hrinfo_id, :integer
    
    Attachment.find_each do |attachment|
      hrinfo = Hrinfo.find_by_user_id(attachment.user_id)
      if hrinfo
        attachment.hrinfo_id = hrinfo.id
        attachment.save!
      end
    end

    remove_column :attachments, :user_id
  end

  def down
    add_column :attachments, :user_id, :integer

    Attachment.find_each do |attachment|
      if attachment.hrinfo_id
        hrinfo = Hrinfo.find(attachment.hrinfo_id)

        attachment.user_id = hrinfo.user_id
        attachment.save!
      end
    end  

    remove_column :attachments, :hrinfo_id
  end
end
