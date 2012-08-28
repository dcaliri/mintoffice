class AssoclateDocumentsToTaxbills < ActiveRecord::Migration
  def change
    add_column :documents, :owner_type, :string
    add_column :documents, :owner_id, :string
  end
end
