class CreateDayworkertaxTable < ActiveRecord::Migration
  def self.up
    create_table :dayworker_taxes, :force => true do |t|
      t.integer :dayworker_id
      t.date :apply_day
      t.string :reason
      t.decimal :amount, :precision => 10, :scale => 2
      t.decimal :tax_amount, :precision => 10, :scale => 2
      t.decimal :pay_amount, :precision => 10, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :dayworker_taxes
  end
end