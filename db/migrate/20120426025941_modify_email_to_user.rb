class ModifyEmailToUser < ActiveRecord::Migration
  def change
    rename_column :users, :email, :notify_email
  end
end