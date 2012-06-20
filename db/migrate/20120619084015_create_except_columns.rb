class CreateExceptColumns < ActiveRecord::Migration
  def change
    create_table :except_columns do |t|
      t.references :user
      t.string :model_name
      t.string :key
      t.text :columns
      t.boolean :default, default: false
      t.timestamps
    end
  end
end
