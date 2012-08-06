module Api
  class CardApprovedSourcesController < Api::ApplicationController
    def export
      collection = Creditcard.preview_stylesheet(:card_approved_sources, 'file' => params[:file])
      raise "approved sources is zero" if collection.empty?

      Creditcard.create_with_stylesheet(:card_approved_sources, params[:file].original_filename)
      render json: {status: 'ok', result: collection}
    rescue => error
      render json: {status: 'invalid', error: error.message}
    end
  end
end

# curl "http://127.0.0.1:3000/api/login.json?user=admin&password=1234"
# curl -F "file=@card_approved_sources.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/card_approved_sources/export"