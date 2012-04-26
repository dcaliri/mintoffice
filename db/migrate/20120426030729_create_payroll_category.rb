class CreatePayrollCategory < ActiveRecord::Migration
  def change
    create_table :payroll_categories, :force => true do |t|
      t.integer :prtype
      t.integer :code
      t.string :title
      t.timestamps
    end
  end
end