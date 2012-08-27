class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.string :title
      t.text :description
      t.timestamps
    end

    create_table :investment_estimations do |t|
      t.references :investment
      t.decimal :amount
      t.date :estimated_at
      t.timestamps
    end
  end
end
