class RenameContactsUserIdToOwnerId < ActiveRecord::Migration
  def change
    rename_column :contacts, :user_id, :owner_id
  end
end
