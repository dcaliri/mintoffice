class AssociateProjectsToCompanies < ActiveRecord::Migration
  class Company < ActiveRecord::Base
    has_many :projects
  end

  class Project < ActiveRecord::Base
    belongs_to :company
  end

  def change
    company = Company.first

    add_column :projects, :company_id, :integer
    Project.all.each do |project|
      project.company = company
      project.save!
    end
  end
end
