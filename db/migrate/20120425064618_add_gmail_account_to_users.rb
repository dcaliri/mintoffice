class AddGmailAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gmail_account, :string
  end
end