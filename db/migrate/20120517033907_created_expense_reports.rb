class CreatedExpenseReports < ActiveRecord::Migration
  def change
    create_table :expense_reports do |t|
      t.references :hrinfo
      t.references :target, polymorphic: true
      t.references :project
      t.text :description
      t.integer :amount
      t.timestamps
    end
  end
end
