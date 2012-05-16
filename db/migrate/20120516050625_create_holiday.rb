class CreateHoliday < ActiveRecord::Migration
  def change
    create_table :holidays, :force => true do |t|
      t.date  :theday
      t.string :dayname
      t.timestamps
    end
  end
end