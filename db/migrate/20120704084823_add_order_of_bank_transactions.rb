class AddOrderOfBankTransactions < ActiveRecord::Migration
  def change
    add_column :bank_transactions, :transact_order, :integer

    order = 0
    BankTransaction.order('transacted_at ASC').each do |bank_transaction|
      bank_transaction.transact_order = order
      puts "BankTransaction: id = #{bank_transaction.id}, transacted at = #{bank_transaction.transacted_at}, order = #{order}"
      bank_transaction.save(validate: false)
      order += 1
    end
  end
end
