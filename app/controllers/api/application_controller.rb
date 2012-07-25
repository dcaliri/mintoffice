module Api
  class ApplicationController < ::ApplicationController
    skip_before_filter :authorize
    skip_before_filter :verify_authenticity_token

    before_filter :find_account
  protected
    def find_account
      @accounts = Account.where(:api_key => request.env['HTTP_API_KEY'])
      @account = @accounts.first if @accounts
      unless @account
        render :json => {:status => :api_key_wrong}
        false
      end
    end
  end
end