class AddMoreInformationOfCardUsedSources < ActiveRecord::Migration
  def up
    add_column :card_used_sources, :used_at, :date
    add_column :card_used_sources, :tax_type, :string
    add_column :card_used_sources, :sales_statement, :string
    add_column :card_used_sources, :nation_statement, :string
    add_column :card_used_sources, :prepayment_statement, :string
    add_column :card_used_sources, :accepted_at, :date
    add_column :card_used_sources, :apply_sales_statement, :string
    add_column :card_used_sources, :purchase_statement, :string
  end
end
