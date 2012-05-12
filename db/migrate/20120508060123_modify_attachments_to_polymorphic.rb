class ModifyAttachmentsToPolymorphic < ActiveRecord::Migration
  class Attachment < ActiveRecord::Base
  end

  def up
    rename_column :attachments, :owner_table_name, :owner_type
    Attachment.all.each do |attachment|
      attachment.owner_type = attachment.owner_type.classify
      attachment.save!
    end
  end

  def down
    Attachment.all.each do |attachment|
      attachment.owner_type = attachment.owner_type.tableize
      attachment.save!
    end
    rename_column :attachments, :owner_type, :owner_table_name
  end
end
