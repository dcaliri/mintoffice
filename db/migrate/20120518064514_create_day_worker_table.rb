class CreateDayWorkerTable < ActiveRecord::Migration
  def change
    create_table :dayworkers, :force => true do |t|
      t.string :juminno
      t.integer :contact_id

      t.timestamps
    end
  end
end