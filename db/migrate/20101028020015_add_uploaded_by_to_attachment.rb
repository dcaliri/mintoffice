class AddUploadedByToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :user_id, :integer, :null => false, :default => 0, :options =>
      "CONSTRAINT fk_attachment_user REFERENCES users(id)"
  end

  def self.down
    remove_column :attachments, :user_id
  end
end
