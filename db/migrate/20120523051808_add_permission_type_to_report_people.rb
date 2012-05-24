class AddPermissionTypeToReportPeople < ActiveRecord::Migration
  def change
    add_column :report_people, :permission_type, :string, default: "read"

    update <<-SQL
      UPDATE report_people SET permission_type = 'write' WHERE report_people.report_id != 0
    SQL
  end
end
