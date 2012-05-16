class CreateReportComments < ActiveRecord::Migration
  def change
    create_table :report_comments do |t|
      t.references :report
      t.references :owner
      t.text :description
      t.timestamps
    end
  end
end
