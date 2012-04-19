class BankAccount < ActiveRecord::Base
  has_many :bank_transactions
  has_many :bank_transfers
end