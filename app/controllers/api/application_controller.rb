module Api
  class ApplicationController < ::ApplicationController
    skip_before_filter :authorize
    skip_before_filter :verify_authenticity_token

    before_filter :find_user
  protected
    def find_user
      @users = User.where(:api_key => request.env['HTTP_API_KEY'])
      @user = @users.first if @users
      unless @user
        render :json => {:status => :api_key_wrong}
        false
      end
    end
  end
end