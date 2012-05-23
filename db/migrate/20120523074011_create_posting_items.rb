class CreatePostingItems < ActiveRecord::Migration
  def change
    create_table :posting_items do |t|
      t.references :posting
      t.references :ledger_account
      t.integer :item_type
      t.integer :amount
      t.timestamps
    end
  end
end
