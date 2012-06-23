class AddRedmineAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :redmine_account, :string
  end
end
