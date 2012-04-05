class PermissionUser < ActiveRecord::Migration
  def self.up
    create_table :permissions_users, :force => true, :id => false do |t|
      t.references :permission
      t.references :user      
      
      t.timestamps
    end
    
    add_index :permissions_users, [:permission_id, :user_id], :unique => true
  end

  def self.down
    remove_index :permissions_users, [:permission_id, :user_id]
    drop_table :permissions_users
  end
end