class AddCardbillIdOfCardHistories < ActiveRecord::Migration
  def change
    add_column :card_histories, :cardbill_id, :integer
  end
end
