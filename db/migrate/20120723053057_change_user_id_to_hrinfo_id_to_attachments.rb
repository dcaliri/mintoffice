class ChangeUserIdToHrinfoIdToAttachments < ActiveRecord::Migration
  def up
    add_column :attachments, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE attachments
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = attachments.user_id)
    SQL

    remove_column :attachments, :user_id
  end

  def down
    add_column :attachments, :user_id, :integer
    
    execute <<-SQL
      UPDATE attachments
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = attachments.hrinfo_id)
    SQL

    remove_column :attachments, :hrinfo_id
  end
end
