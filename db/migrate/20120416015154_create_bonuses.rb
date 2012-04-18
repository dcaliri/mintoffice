class CreateBonuses < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.date :given_at
      t.decimal :amount, default: 0
      t.text :note
      t.references :user
      t.timestamps
    end
  end
end
