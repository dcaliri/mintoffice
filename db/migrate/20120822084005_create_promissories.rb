class CreatePromissories < ActiveRecord::Migration
  def change
    create_table :promissories do |t|
      t.date :expired_at
      t.date :published_at
      t.decimal :amount
      t.timestamps
    end
  end
end
