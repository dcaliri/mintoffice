module Api
  class CommutesController < Api::ApplicationController
    respond_to :json
    before_filter :find_user

    def go
      @commute = @user.commutes.build
      @commute.go!
      Attachment.save_for(@commute, @user, uploaded_file: params[:file])
      respond_with @commute
    end

    def leave
      @commutes = @user.commutes.where(leave: nil)
      if @commutes
        @commute = @commutes.last
        @commute.leave!
        Attachment.save_for(@commute, @user, uploaded_file: params[:file])
      else
        @commute = Commute.new
      end
      respond_with @commute
    end

    private
    def find_user
      @user = User.authenticate(params[:user], params[:password])
    end
  end
end

# curl -F "file=@waldo.jpg;" "http://mintoffice.dev/api/commutes/go?user=admin&password=1234"
# curl -F "file=@waldo.jpg;" "http://mintoffice.dev/api/commutes/leave?user=admin&password=1234"
