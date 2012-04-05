class AddUserIdHrinfo < ActiveRecord::Migration
  def self.up
    add_column :hrinfos, :user_id, :integer
  end

  def self.down
    remove_column :hrinfos, :user_id
  end
end