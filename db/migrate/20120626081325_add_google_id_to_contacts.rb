class AddGoogleIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :google_id, :string
  end
end
