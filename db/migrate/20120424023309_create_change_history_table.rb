class CreateChangeHistoryTable < ActiveRecord::Migration
  def change
    create_table :change_histories, :force => true do |t|
      t.string :fieldname
      t.string :before_value
      t.string :after_value
      t.integer :user_id
      t.references :changable, :polymorphic => true
      t.timestamps
    end
  end
end