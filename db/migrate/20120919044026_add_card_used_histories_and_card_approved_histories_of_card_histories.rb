class AddCardUsedHistoriesAndCardApprovedHistoriesOfCardHistories < ActiveRecord::Migration
  def change
    add_column :card_histories, :card_used_history_type, :string
    add_column :card_histories, :card_used_history_id, :integer
    add_column :card_histories, :card_approved_history_type, :string
    add_column :card_histories, :card_approved_history_id, :integer
  end
end
