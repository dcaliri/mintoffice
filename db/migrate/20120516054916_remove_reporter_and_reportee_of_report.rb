class RemoveReporterAndReporteeOfReport < ActiveRecord::Migration
  def up
    remove_column :reports, :reporter_id
    remove_column :reports, :reportee_id
  end

  def down
    add_column :reports, :reportee_id, :integer
    add_column :reports, :reporter_id, :integer
  end
end
