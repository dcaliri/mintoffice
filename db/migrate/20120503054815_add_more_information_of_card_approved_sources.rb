class AddMoreInformationOfCardApprovedSources < ActiveRecord::Migration
  def change
    add_column :card_approved_sources, :money_foreign, :string
    add_column :card_approved_sources, :money_type, :string
    add_column :card_approved_sources, :money_type_info, :string
    add_column :card_approved_sources, :money_dollar, :string
  end
end
