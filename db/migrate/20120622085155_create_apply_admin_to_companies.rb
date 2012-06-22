class CreateApplyAdminToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :apply_admin_id, :integer
  end
end
