class RemovePermissionTypeToReportPeople < ActiveRecord::Migration
  def up
    remove_column :report_people, :permission_type
  end

  def down
    add_column :report_people, :permission_type, :string, default: 'read'
  end
end
