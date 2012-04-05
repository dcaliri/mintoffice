class AddAddressToHrinfo < ActiveRecord::Migration
  def self.up
    add_column :hrinfos, :address, :string
    add_column :hrinfos, :email, :string
    add_column :hrinfos, :mphone, :string
    add_column :hrinfos, :position, :string
  end

  def self.down
    remove_column :hrinfos, :position
    remove_column :hrinfos, :mphone
    remove_column :hrinfos, :email
    remove_column :hrinfos, :address
  end
end