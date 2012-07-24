class ChangeUserIdToHrinfoIdToDocumentOwners < ActiveRecord::Migration
  def up
    add_column :document_owners, :hrinfo_id, :integer

    execute <<-SQL
      UPDATE document_owners
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = document_owners.user_id)
    SQL

    remove_column :document_owners, :user_id
  end

  def down
    add_column :document_owners, :user_id, :integer
    
    execute <<-SQL
      UPDATE document_owners
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = document_owners.hrinfo_id)
    SQL

    remove_column :document_owners, :hrinfo_id
  end
end
