class AddHrinfosReferencesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :hrinfo_id, :integer
  end
end
