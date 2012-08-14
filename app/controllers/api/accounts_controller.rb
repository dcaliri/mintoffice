module Api
  class AccountsController < Api::ApplicationController
    skip_before_filter :find_account
    respond_to :json

    def login
      @account = Account.authenticate(params[:account], params[:password])
      if @account
        @account.create_api_key(params[:account], params[:password])
        render :json => {:status => :ok, :account => @account}
      else
        render :json => {:status => :not_found}
      end
    end
  end
end