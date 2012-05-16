class AssociateBusinessClientsToCompanies < ActiveRecord::Migration
  class Company < ActiveRecord::Base
    has_many :business_clients
  end

  class BusinessClient < ActiveRecord::Base
    belongs_to :company
  end

  def change
    company = Company.first

    add_column :business_clients, :company_id, :integer
    BusinessClient.all.each do |client|
      client.company = company
      client.save!
    end
  end
end
