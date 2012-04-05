class AddContenttypeToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :contenttype, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :attachments, :contenttype
  end
end
