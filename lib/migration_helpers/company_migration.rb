module MigrationHelpers
  module CompanyMigration
    def change_company(class_name)
      add_column class_name.downcase.pluralize, :company_id, :integer

      company = Company.first
      class_name.constantize.update_all(company_id: company.id)
    end
  end
end