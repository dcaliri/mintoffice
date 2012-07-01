class AddBankAccountIdToCreditcards < ActiveRecord::Migration
  def change
    add_column :creditcards, :bank_account_id, :integer
  end
end
