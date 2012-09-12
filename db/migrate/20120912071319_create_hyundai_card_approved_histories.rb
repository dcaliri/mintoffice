class CreateHyundaiCardApprovedHistories < ActiveRecord::Migration
  def change
    create_table  :hyundai_card_approved_histories do |t|
      t.date      :transacted_date
      t.time      :transacted_time
      t.string    :card_number
      t.string    :money
      t.string    :money_us
      t.string    :card_holder_name
      t.string    :store_name
      t.string    :nation
      t.string    :status
      t.string    :approve_number
      t.string    :nation_statement
      t.string    :refuse_reason
      t.timestamps
    end
  end
end
