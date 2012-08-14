class RenameGoogleappsUsername < ActiveRecord::Migration
  def change
  	rename_column :companies, :google_apps_username, :google_apps_accountname
	  rename_column :companies, :redmine_username, :redmine_accountname
  end
end
