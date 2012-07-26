module Api
  class ApplicationController < ::ApplicationController
    skip_before_filter :authorize
    skip_before_filter :verify_authenticity_token

    before_filter :find_account
  protected
    def current_account
      @account ||= Account.find_by_api_key(request.env['HTTP_API_KEY'])
    end

    def find_account
      unless current_account
        render :json => {:status => :api_key_wrong}
        false
      end
    end
  end
end