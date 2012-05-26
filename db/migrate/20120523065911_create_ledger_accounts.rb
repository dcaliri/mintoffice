class CreateLedgerAccounts < ActiveRecord::Migration
  def change
    create_table :ledger_accounts do |t|
      t.string :title
      t.integer :category
      t.timestamps
    end
  end
end
