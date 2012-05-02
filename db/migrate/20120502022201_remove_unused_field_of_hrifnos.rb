class RemoveUnusedFieldOfHrifnos < ActiveRecord::Migration
  def up
    remove_column :hrinfos, :address
    remove_column :hrinfos, :email
    remove_column :hrinfos, :mphone
  end

  def down
    add_column :hrinfos, :address, :string
    add_column :hrinfos, :email, :string
    add_column :hrinfos, :mphone, :string
  end
end
