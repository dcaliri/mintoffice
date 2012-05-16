class CreateReportPeople < ActiveRecord::Migration
  def change
    create_table :report_people do |t|
      t.references :hrinfo
      t.references :report
      t.references :prev
      t.timestamps
    end
  end
end
