class CreateProjectAssignRate < ActiveRecord::Migration
  def change
    create_table :project_assign_rates do |t|
      t.references :project_assign_info
      t.date :start
      t.date :finish
      t.integer :percentage
      t.timestamp
    end
  end
end
