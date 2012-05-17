class AssociateContactToCompanies < ActiveRecord::Migration
  include MigrationHelpers::CompanyMigration

  def change
    rename_column :contacts, :company, :company_name
    change_company("Contact".to_s)
  end
end
