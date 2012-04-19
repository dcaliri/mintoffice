class BankTransactionsController < ApplicationController
  expose(:bank_transactions) { BankTransaction.all }
  expose(:bank_transaction)
end