class AddCreditcardIdOfCardHistories < ActiveRecord::Migration
  def change
    add_column :card_histories, :creditcard_id, :integer
  end
end
