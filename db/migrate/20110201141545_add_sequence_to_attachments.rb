class AddSequenceToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :seq, :integer
  end

  def self.down
    remove_column :attachments, :seq
  end
end