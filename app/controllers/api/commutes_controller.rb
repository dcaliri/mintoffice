module Api
  class CommutesController < Api::ApplicationController
    before_filter :find_user

    def checkin
      @commute = @user.commutes.build
      @commute.go!
      Attachment.save_for(@commute, @user, uploaded_file: params[:file])
      render :json => {:status => :ok, :commute => @commute}
    end

    def checkout
      @commutes = @user.commutes.where(leave: nil)
      unless @commutes.empty?
        @commute = @commutes.last
        @commute.leave!
        Attachment.save_for(@commute, @user, uploaded_file: params[:file])
        render :json => {:status => :ok, :commute => @commute}
      else
        render :json => {:status => :not_found}
      end
    end

    private
    def find_user
      key = request.env['HTTP_API_KEY'][0..-2]
      @users = User.where(:api_key => key)
      @user = @users.first if @users
    end
  end
end

# curl "http://mintoffice.dev/api/login.json?user=admin&password=1234"
# curl -F "file=@waldo.jpg;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f", "http://mintoffice.dev/api/commutes/checkin"
# curl -F "file=@waldo.jpg;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f", "http://mintoffice.dev/api/commutes/checkout"
