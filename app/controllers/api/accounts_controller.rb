module Api
  class AccountsController < Api::ApplicationController
    skip_before_filter :find_account
    respond_to :json

    def login
      @account = Account.authenticate(params[:user], params[:password])
      if @account
        @account.create_api_key!(params[:user], params[:password])
        render :json => {:status => :ok, :user => @account}
      else
        render :json => {:status => :not_found}
      end
    end
  end
end