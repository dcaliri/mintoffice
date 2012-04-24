class AddMoreFieldToBankTransfer < ActiveRecord::Migration
  def change
    add_column :bank_transfers, :cms_code, :string
    add_column :bank_transfers, :currency_code, :string
  end
end
