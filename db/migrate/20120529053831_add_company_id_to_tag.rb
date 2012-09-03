class AddCompanyIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :company_id, :integer

    # company = Company.find_or_create_by_name("mintech")
    company = Company.first
    Tag.update_all(company_id: company.id)
  end
end
