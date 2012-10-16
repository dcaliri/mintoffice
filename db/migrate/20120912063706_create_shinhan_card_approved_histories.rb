class CreateShinhanCardApprovedHistories < ActiveRecord::Migration
  def change
    create_table :shinhan_card_approved_histories do |t|
      t.datetime :used_at
      t.string   :approve_no
      t.string   :card_name
      t.string   :card_holder_name
      t.string   :store_name
      t.decimal  :money, precision: 10, scale: 2
      t.string   :used_type
      t.string   :monthly_duration
      t.datetime :card_type
      t.datetime :canceled_at
      t.string   :purchase_status
      t.date     :will_be_paied_at
    end
  end
end
