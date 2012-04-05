class AddAttachmentCoumnToCardbill < ActiveRecord::Migration
  def self.up
    add_column :cardbills, :attachment_id, :integer
  end

  def self.down
    remove_column :cardbills, :attachment_id
  end
end