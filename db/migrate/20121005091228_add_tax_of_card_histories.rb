class AddTaxOfCardHistories < ActiveRecord::Migration
  def up
    add_column :card_histories, :tax, :decimal, precision: 10, scale: 2
    CardHistory.find_each do |history|
      if history.card_used_history_type == "ShinhanCardUsedHistory"
        history.update_column(:tax, history.used.tax)
      end
    end
  end

  def down
    remove_column :card_histories, :tax
  end
end
