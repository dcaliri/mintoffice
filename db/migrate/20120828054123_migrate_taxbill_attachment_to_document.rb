class MigrateTaxbillAttachmentToDocument < ActiveRecord::Migration
  def up
    company = Company.find_or_create_by_name("mintech")
    execute <<-SQL
      INSERT INTO documents (title, company_id, owner_type, owner_id, created_at, updated_at)
      SELECT "taxbill" + id, "#{company.id}", 'Taxbill', id, date('now'), date('now')
      FROM taxbills;
    SQL

    execute <<-SQL
      UPDATE attachments
      SET owner_type = "Document", owner_id = (SELECT id
      FROM documents
      WHERE documents.owner_type = "Taxbill")
      WHERE attachments.owner_type = "Taxbill"
    SQL
  end

  def down
    execute <<-SQL
      UPDATE attachments
      SET owner_type = "Taxbill", owner_id = (SELECT owner_id
      FROM documents
      WHERE documents.owner_type = "Taxbill")
      WHERE attachments.owner_type = "Document"
    SQL

    execute <<-SQL
      DELETE FROM documents WHERE documents.owner_type = 'Taxbill'
    SQL
  end
end





