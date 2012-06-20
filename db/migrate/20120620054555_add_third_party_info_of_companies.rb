class AddThirdPartyInfoOfCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :google_apps_domain, :string
    add_column :companies, :google_apps_username, :string
    add_column :companies, :google_apps_password, :string
    add_column :companies, :redmine_domain, :string
    add_column :companies, :redmine_username, :string
    add_column :companies, :redmine_password, :string
    add_column :companies, :default_password, :string
  end
end
