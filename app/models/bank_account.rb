class BankAccount < ActiveRecord::Base
  has_many :bank_transactions
end