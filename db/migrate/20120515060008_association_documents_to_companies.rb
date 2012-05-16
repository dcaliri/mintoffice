class AssociationDocumentsToCompanies < ActiveRecord::Migration
  class Company < ActiveRecord::Base
    has_many :documents
  end

  class Document < ActiveRecord::Base
    belongs_to :company
  end

  def change
    company = Company.first

    add_column :documents, :company_id, :integer
    Document.all.each do |document|
      document.company = company
      document.save!
    end
  end
end
