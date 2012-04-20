class CreateCardApprovedSources < ActiveRecord::Migration
  def change
    create_table :card_approved_sources do |t|
      t.references  :creditcard
      t.datetime    :used_at
      t.string      :approve_no
      t.string      :card_holder_name
      t.string      :store_name
      t.integer     :money
      t.string      :used_type
      t.string      :monthly_duration
      t.string      :card_type
      t.datetime    :canceled_at
      t.string      :status
      t.datetime    :will_be_paied_at
      t.timestamps
    end
  end
end
