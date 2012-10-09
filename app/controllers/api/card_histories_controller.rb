module Api
  class CardHistoriesController < Api::ApplicationController
    def shinhan_card_used_histories
      export(ShinhanCardUsedHistory, params[:file])
    end

    def shinhan_card_approved_histories
      export(ShinhanCardApprovedHistory, params[:file])
    end

    def hyundai_card_used_histories
      export(HyundaiCardUsedHistory, params[:file])
    end
    
    def hyundai_card_approved_histories
      export(HyundaiCardApprovedHistory, params[:file])
    end

    def oversea_card_approved_histories
      export(OverseaCardApprovedHistory, params[:file])
    end

    def export(class_name, file)
      collection = class_name.preview_stylesheet('file' => file)
      raise "excel file is empty" if collection.empty?

      class_name.create_with_stylesheet(file.original_filename)
      CardHistory.generate

      render json: {status: 'ok', result: collection}
    rescue => error
      render json: {status: 'invalid', error: error.message}
    end
  end
end


# curl -F "file=@h-common-use.xlsx;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/hyundai_card_used_histories/export"

# curl "http://mintoffice.dev/api/login.json?user=admin&password=1234"
# curl -F "file=@shinhan_card_used_histories.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/shinhan_card_used_histories/export"
# curl -F "file=@shinhan_card_approved_histories.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/shinhan_card_approved_histories/export"
# curl -F "file=@hyundai_card_used_histories.xlsx;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/hyundai_card_used_histories/export"
# curl -F "file=@hyundai_card_approved_histories.xlsx;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/hyundai_card_approved_histories/export"
# curl -F "file=@oversea_card_approved_histories.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/oversea_card_approved_histories/export"

# curl "http://127.0.0.1:3000/api/login.json?user=admin&password=1234"
# curl -F "file=@card_approved_sources.xls;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/shinhan_card_used_histories/export"

# curl -F "file=@card_approves_sources_oversea.xls;" -F "oversea=true" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://127.0.0.1:3000/api/card_approved_sources/export"