class RemoveTimestampsOfAllHabtm < ActiveRecord::Migration
  def change
    remove_index :documents_tags, [:document_id, :tag_id]
    remove_column :documents_tags, :created_at
    remove_column :documents_tags, :updated_at
    add_index :documents_tags, [:document_id, :tag_id], :unique => true

    remove_column :projects_users, :created_at
    remove_column :projects_users, :updated_at
  end
end
