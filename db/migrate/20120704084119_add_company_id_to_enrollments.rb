class AddCompanyIdToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :company_id, :integer
  end
end
