module Api
  class CardUsedSourcesController < Api::ApplicationController
    def export
      collection = Creditcard.preview_stylesheet(:card_used_sources, 'file' => params[:file])
      raise "used sources is zero" if collection.empty?

      Creditcard.create_with_stylesheet(:card_used_sources, params[:file].original_filename)
      render json: {status: 'ok', result: collection}
    rescue => error
      render json: {status: 'invalid', error: error.message}
    end
  end
end

# curl "http://127.0.0.1:3000/api/login.json?user=admin&password=1234"
# curl -F "file=@card_used_sources.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/card_used_sources/export"