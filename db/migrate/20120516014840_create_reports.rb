class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :target, polymorphic: true
      t.references :reportee
      t.references :reporter
      t.string :status
    end
  end
end
