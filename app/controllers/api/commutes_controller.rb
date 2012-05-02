module Api
  class CommutesController < Api::ApplicationController
    respond_to :json

    def create
      logger.info "params = #{params}"
      @user = User.authenticate(params[:user], params[:password])
      logger.info "user = #{{user}}"
      @commute = @user.commutes.build
      @commute.go!
      Attachment.save_for(@commute, @user, params[:attachment])
      respond_with @commute
    end
  end
end

#curl -F "file=@waldo.jpg;" "http://mintoffice.dev/api/commutes?user=admin&password=1234"