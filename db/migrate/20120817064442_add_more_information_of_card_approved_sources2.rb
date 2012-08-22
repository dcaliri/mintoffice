class AddMoreInformationOfCardApprovedSources2 < ActiveRecord::Migration
  def change
    add_column :card_approved_sources, :money_us, :string
    add_column :card_approved_sources, :nation, :string
    add_column :card_approved_sources, :nation_statement, :string
    add_column :card_approved_sources, :refuse_reason, :string
  end
end
