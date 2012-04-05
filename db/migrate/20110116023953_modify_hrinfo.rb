class ModifyHrinfo < ActiveRecord::Migration
  def self.up
    add_column :hrinfos, :joined_on, :date
    add_column :hrinfos, :retired_on, :date
  end

  def self.down
    remove_column :hrinfos, :retired_on
    remove_column :hrinfos, :joined_on
  end
end