module Api
  class BankTransfersController < Api::ApplicationController
    def export
      transfers = BankTransfer.preview_stylesheet(params[:bank_type], 'file' => params[:file])
      raise "bank transfer is zero" if transfers.empty?

      BankTransfer.create_with_stylesheet(params[:bank_type], params[:file].original_filename)
      render json: {status: 'ok', result: transfers}
    rescue => error
      render json: {status: 'invalid', error: error.message}
    end
  end
end

# curl "http://127.0.0.1:3000/api/login.json?user=admin&password=1234"
# curl -F "file=@bank_transfers.xls;" -F "bank_type=shinhan" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/bank_transfers/export"