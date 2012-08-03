class MigrationAllMoneyToDecimal < ActiveRecord::Migration
  def up
    change_column :bank_transactions, :in, :decimal
    change_column :bank_transactions, :out, :decimal
    change_column :bank_transactions, :remain, :decimal
    change_column :bank_transactions, :promissory_check_amount, :decimal

    change_column :bank_transfers, :money, :decimal
    change_column :bank_transfers, :transfer_fee, :decimal
    change_column :bank_transfers, :error_money, :decimal

    change_column :card_approved_sources, :money, :decimal

    change_column :card_used_sources, :money_krw, :decimal
    change_column :card_used_sources, :money_foreign, :decimal
    change_column :card_used_sources, :price, :decimal
    change_column :card_used_sources, :tax, :decimal
    change_column :card_used_sources, :tip, :decimal

    change_column :expense_reports, :amount, :decimal

    change_column :posting_items, :amount, :decimal
  end

  def down
    change_column :bank_transactions, :in, :integer
    change_column :bank_transactions, :out, :integer
    change_column :bank_transactions, :remain, :integer
    change_column :bank_transactions, :promissory_check_amount, :integer

    change_column :bank_transfers, :money, :integer
    change_column :bank_transfers, :transfer_fee, :integer
    change_column :bank_transfers, :error_money, :integer

    change_column :card_approved_sources, :money, :integer

    change_column :card_used_sources, :money_krw, :integer
    change_column :card_used_sources, :money_foreign, :integer
    change_column :card_used_sources, :price, :integer
    change_column :card_used_sources, :tax, :integer
    change_column :card_used_sources, :tip, :integer

    change_column :expense_reports, :amount, :integer

    change_column :posting_items, :amount, :integer
  end
end
