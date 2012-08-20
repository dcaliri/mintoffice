class CreateBankbooks < ActiveRecord::Migration
  def change
    create_table :bankbooks do |t|
      t.string :name
      t.string :number
      t.string :account_holder
      t.timestamps
    end
  end
end
