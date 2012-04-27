class BankAccount < ActiveRecord::Base
  has_many :bank_transactions, :dependent => :destroy
  has_many :bank_transfers, :dependent => :destroy

  class << self
    def newest_transaction
      BankTransaction.order('transacted_at DESC').first.transacted_at
    end

    def oldest_transaction
      BankTransaction.order('transacted_at ASC').first.transacted_at - 1.month
    end
  end
end