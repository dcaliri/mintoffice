class CreateDocumentTagsTable < ActiveRecord::Migration
  def self.up
    create_table :documents_tags, :force => true, :id => false do |t|
      t.references :document
      t.references :tag

      t.timestamps
    end
    add_index :documents_tags, [:document_id, :tag_id], :unique => true
  end

  def self.down
    remove_index :documents_tags, :column => [:document_id, :tag_id]
    drop_table :documents_tags
  end
end