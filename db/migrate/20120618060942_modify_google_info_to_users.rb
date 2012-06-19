class ModifyGoogleInfoToUsers < ActiveRecord::Migration
  def up
    rename_column :users, :gmail_account, :google_account
    remove_column :users, :google_app_account
  end

  def down
    add_column :users, :google_app_account, :string
      rename_column :users, :google_account, :gmail_account
  end
end
