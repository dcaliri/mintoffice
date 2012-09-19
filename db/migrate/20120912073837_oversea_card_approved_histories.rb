class OverseaCardApprovedHistories < ActiveRecord::Migration
  def change
    create_table  :oversea_card_approved_histories do |t|
      t.datetime  :used_at
      t.string    :approved_number
      t.string    :card_name
      t.string    :card_holder_name
      t.string    :store_name
      t.string    :money
      t.string    :money_locale
      t.string    :money_locale_currency
      t.string    :money_locale_name
      t.string    :money_us
      t.string    :used_type
      t.string    :card_type
      t.datetime  :refused_at
      t.string    :purchase_status
      t.date      :will_be_paied_at
      t.timestamps
    end
  end
end
