class ModifyDecimalOfMoney < ActiveRecord::Migration
  def up
    change_column :card_approved_sources, :money, :decimal, precision: 10, scale: 2

    change_column :card_used_sources, :money_krw, :decimal, precision: 10, scale: 2
    change_column :card_used_sources, :money_foreign, :decimal, precision: 10, scale: 2
    change_column :card_used_sources, :price, :decimal, precision: 10, scale: 2
    change_column :card_used_sources, :tax, :decimal, precision: 10, scale: 2
    change_column :card_used_sources, :tip, :decimal, precision: 10, scale: 2

    change_column :expense_reports, :amount, :decimal, precision: 10, scale: 2

    change_column :cardbills, :amount, :decimal, precision: 10, scale: 2
    change_column :cardbills, :vat, :decimal, precision: 10, scale: 2
    change_column :cardbills, :servicecharge, :decimal, precision: 10, scale: 2
    change_column :cardbills, :totalamount, :decimal, precision: 10, scale: 2

    change_column :pettycashes, :inmoney, :decimal, precision: 10, scale: 2
    change_column :pettycashes, :outmoney, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :card_approved_sources, :money, :decimal, precision: 10, scale: 0

    change_column :card_used_sources, :money_krw, :decimal, precision: 10, scale: 0
    change_column :card_used_sources, :money_foreign, :decimal, precision: 10, scale: 0
    change_column :card_used_sources, :price, :decimal, precision: 10, scale: 0
    change_column :card_used_sources, :tax, :decimal, precision: 10, scale: 0
    change_column :card_used_sources, :tip, :decimal, precision: 10, scale: 0

    change_column :expense_reports, :amount, :decimal, precision: 10, scale: 0

    change_column :cardbills, :amount, :decimal, precision: 10, scale: 0
    change_column :cardbills, :vat, :decimal, precision: 10, scale: 0
    change_column :cardbills, :servicecharge, :decimal, precision: 10, scale: 0
    change_column :cardbills, :totalamount, :decimal, precision: 10, scale: 0

    change_column :pettycashes, :inmoney, :decimal, precision: 10, scale: 0
    change_column :pettycashes, :outmoney, :decimal, precision: 10, scale: 0
  end
end
