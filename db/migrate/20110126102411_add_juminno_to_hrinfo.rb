class AddJuminnoToHrinfo < ActiveRecord::Migration
  def self.up
    add_column :hrinfos, :juminno, :string
  end

  def self.down
    remove_column :hrinfos, :juminno
  end
end