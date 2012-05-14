class ChangeContactColumnePrivateToisprivate < ActiveRecord::Migration
  def change
    rename_column :contacts, :private, :isprivate
  end
end