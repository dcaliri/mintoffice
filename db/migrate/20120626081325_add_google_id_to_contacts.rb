class AddGoogleIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :google_id, :string
    add_column :contacts, :google_etag, :string
  end
end
