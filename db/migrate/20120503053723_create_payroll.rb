class CreatePayroll < ActiveRecord::Migration
  def change
    create_table :payrolls, :force => true do |t|
      t.date :payday
      t.integer :user_id
      t.timestamps
    end
  end
end