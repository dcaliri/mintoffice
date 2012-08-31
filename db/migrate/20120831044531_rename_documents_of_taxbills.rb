# encoding: UTF-8

class RenameDocumentsOfTaxbills < ActiveRecord::Migration
  class ::Document < ActiveRecord::Base
    belongs_to :owner, polymorphic: true
  end

  class ::Taxbill < ActiveRecord::Base
    has_one :document, as: :owner
    belongs_to :taxman
  end

  class ::Taxman < ActiveRecord::Base
    belongs_to :business_client
    has_many :taxbills
  end

  class ::BusinessClient < ActiveRecord::Base
    belongs_to :company
    has_many :taxmen
  end

  def up
    documents = Document.where(owner_type: "Taxbill")
    documents.each do |document|
      taxbill = document.owner
      if taxbill
        business_client_name = taxbill.taxman.business_client.name rescue "unknown"
        taxman_name = taxbill.taxman.fullname rescue "unknown"

        title = "세금계산서(#{taxbill.id}) #{business_client_name} - #{taxman_name}"

        document.title = title
        document.save!
      end
    end
  end

  def down
    documents = Document.where(owner_type: "Taxbill")
    documents.each do |document|
      taxbill = document.owner
      if taxbill
        title = taxbill.id

        document.title = title
        document.save!
      end
    end
  end
end
