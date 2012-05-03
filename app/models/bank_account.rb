class BankAccount < ActiveRecord::Base
  has_many :bank_transactions, :dependent => :destroy
  has_many :bank_transfers, :dependent => :destroy

  class << self
    def transaction_per_period(query)
      collection = BankTransaction.where('transacted_at IS NOT NULL').order(query)
      if collection.empty?
        Time.zone.now
      else
        collection.first.transacted_at
      end
    end

    def newest_transaction
      transaction_per_period('transacted_at DESC')
    end

    def oldest_transaction
      transaction_per_period('transacted_at ASC') - 1.month
    end
  end
end