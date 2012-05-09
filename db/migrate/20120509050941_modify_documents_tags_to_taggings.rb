class ModifyDocumentsTagsToTaggings < ActiveRecord::Migration
  class DocumentsTag < ActiveRecord::Base
  end
  class Tagging < ActiveRecord::Base
  end

  def change
    create_table :taggings do |t|
      t.string :name
      t.references :target, :polymorphic => true
      t.references :tag
      t.timestamps
    end

    DocumentsTag.all.each do |dt|
      Tagging.create!(target_type: "Document", target_id: dt.document_id, tag_id: dt.tag_id)
    end
    # rename_table :documents_tags, :taggings
    # rename_column :taggings, :document_id, :target_id
    # add_column :taggings, :target_type, :string
    #
    # Tagging.all.each_with_index do |tagging, index|
    #   tagging.id = index+1
    #   tagging.target_type = "Document"
    #   tagging.save!
    # end
  end
end
