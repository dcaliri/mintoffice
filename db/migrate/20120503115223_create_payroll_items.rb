class CreatePayrollItems < ActiveRecord::Migration
  def change
    create_table :payroll_items, :force => true do |t|
      t.integer :payroll_id
      t.integer :payroll_category_id
      t.decimal :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end
end