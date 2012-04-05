class CreateGroupUsersTable < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :force => true, :id => false do |t|
      t.references :group
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :groups_users
  end
end