class ChangeUserIdToHrinfoIdToDocumentOwners < ActiveRecord::Migration
  def up
    add_column :document_owners, :hrinfo_id, :integer
    
    DocumentOwner.find_each do |document_owner|
      hrinfo = Hrinfo.find_by_user_id(document_owner.user_id)
      if hrinfo
        document_owner.hrinfo_id = hrinfo.id
        document_owner.save!
      end
    end

    remove_column :document_owners, :user_id
  end

  def down
    add_column :document_owners, :user_id, :integer

    DocumentOwner.find_each do |document_owner|
      if document_owner.hrinfo_id
        hrinfo = Hrinfo.find(document_owner.hrinfo_id)

        document_owner.user_id = hrinfo.user_id
        document_owner.save!
      end
    end

    remove_column :document_owners, :hrinfo_id
  end
end
