module Api
  class UsersController < Api::ApplicationController
    respond_to :json

    def login
      @user = User.authenticate(params[:user], params[:password])
      if @user
        @user.create_api_key(params[:user], params[:password])
        render :json => {:status => :ok, :user => @user}
      else
        render :json => {:status => :not_found}
      end
    end
  end
end