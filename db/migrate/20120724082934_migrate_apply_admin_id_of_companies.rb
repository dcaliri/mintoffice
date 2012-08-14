class MigrateApplyAdminIdOfCompanies < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE companies
      SET apply_admin_id = (SELECT users.person_id
      FROM users
      WHERE users.id = companies.apply_admin_id)
    SQL
  end

  def down
    execute <<-SQL
      UPDATE companies
      SET apply_admin_id = (SELECT users.id
      FROM users
      WHERE users.person_id = companies.apply_admin_id)
    SQL
  end
end
