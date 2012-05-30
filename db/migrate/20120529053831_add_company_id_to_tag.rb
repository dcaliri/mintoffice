class AddCompanyIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :company_id, :integer

    company = Company.find_by_name("minttech")
    Tag.update_all(company_id: company.id)
  end
end
