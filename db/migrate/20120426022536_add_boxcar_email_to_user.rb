class AddBoxcarEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :boxcar_account, :string
    add_column :users, :email, :string
  end
end