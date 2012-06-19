class AddGoogleAppAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_app_account, :string
  end
end
