module Api
  class BankTransactionsController < Api::ApplicationController

    def export
    	account = BankAccount.find_by_number(params[:bank_account])
      raise "Couldn't find bank account" unless account

      collection = BankTransaction.preview_stylesheet(account, account.name_, 'file' => params[:file])
      raise "bank transaction is zero" if collection.empty?

      invalid = collection.find_valid_transaction
      if invalid
        render json: {status: 'invalid', result: 'invalid bank transaction', invalid_transaction: invalid}
      else
        BankTransaction.create_with_stylesheet(account, account.name_, params[:file].original_filename)
        render json: {status: 'ok', result: collection[1..-2]}
      end

    rescue => error
      render json: {status: 'invalid', error: error.message}
    end


  end
end

# curl "http://127.0.0.1:3000/api/login.json?user=admin&password=1234"
# curl -F "file=@bank_transactions.xls;" -F "bank_account=2813648" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/bank_transactions/export"
# curl -F "file=@bank_transactions.xls;" -F "bank_account=2813648" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/bank_transactions/export"






