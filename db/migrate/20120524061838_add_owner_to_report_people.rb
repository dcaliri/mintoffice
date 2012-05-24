class AddOwnerToReportPeople < ActiveRecord::Migration
  def change
    add_column :report_people, :owner, :boolean, default: false
  end
end
