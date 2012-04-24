class CreateBankTransaction < ActiveRecord::Migration
  def change
    create_table :bank_transactions do |t|
      t.references  :bank_account
      t.datetime    :transacted_at
      t.string      :transaction_type
      t.integer     :in,              default: 0
      t.integer     :out,             default: 0
      t.text        :note
      t.integer     :remain,          default: 0
      t.string      :branchname
      t.timestamps
    end
  end
end
