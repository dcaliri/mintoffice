class CreateBankTransfers < ActiveRecord::Migration
  def change
    create_table :bank_transfers do |t|
      t.references :bank_account
      t.string :transfer_type
      t.datetime :transfered_at
      t.string :result
      t.string :out_bank_account
      t.string :in_bank_name
      t.string :in_bank_account
      t.integer :money
      t.integer :transfer_fee
      t.integer :error_money
      t.datetime :registered_at
      t.string :error_code
      t.string :transfer_note
      t.string :incode
      t.string :out_account_note
      t.string :in_account_note
      t.string :in_person_name
    end
  end
end