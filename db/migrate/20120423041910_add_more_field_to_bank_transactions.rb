class AddMoreFieldToBankTransactions < ActiveRecord::Migration
  def change
    add_column :bank_transactions, :out_bank_account, :string
    add_column :bank_transactions, :out_bank_name, :string
    add_column :bank_transactions, :promissory_check_amount, :integer
    add_column :bank_transactions, :cms_code, :string
  end
end
