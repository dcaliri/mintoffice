class AddCardNoToCardUsedSources < ActiveRecord::Migration
  def change
    add_column :card_approved_sources, :card_no, :string
  end
end
