class MigrateTaxbillAttachmentToDocument < ActiveRecord::Migration
  def up
    # company = Company.find_or_create_by_name("mintech")
    company = Company.first
    execute <<-SQL
      INSERT INTO documents (title, company_id, owner_type, owner_id, created_at, updated_at)
      SELECT "taxbill" + id, "#{company.id}", 'Taxbill', id, date('now'), date('now')
      FROM taxbills;
    SQL

    Attachment.where(owner_type: "Taxbill").each do |attachment|
      taxbill = Taxbill.find_by_id(attachment.owner_id)
      if taxbill
        document = taxbill.document
        if document
          attachment.owner_type = "Document"
          attachment.owner_id = document.id
          attachment.save!
        end
      end
    end
  end

  def down
    Attachment.where(owner_type: "Document").each do |attachment|
      document = Document.find_by_id(attachment.owner_id)

      if document
        taxbill = document.owner
        if taxbill
          attachment.owner_type = "Taxbill"
          attachment.owner_id = taxbill.id
          attachment.save!
        end
      end
    end

    execute <<-SQL
      DELETE FROM documents WHERE documents.owner_type = 'Taxbill'
    SQL
  end
end