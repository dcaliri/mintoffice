class AddDaumAccountAndNateAccountOfUsers < ActiveRecord::Migration
  def change
    add_column :users, :daum_account, :string
    add_column :users, :nate_account, :string
  end
end
