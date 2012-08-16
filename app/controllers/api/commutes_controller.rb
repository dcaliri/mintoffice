module Api
  class CommutesController < Api::ApplicationController
    def checkin
      @commute = current_employee.commutes.build
      @commute.go!
      Attachment.save_for(@commute, current_employee, uploaded_file: params[:file])
      render :json => {:status => :ok, :commute => @commute}
    rescue ActiveRecord::RecordInvalid
      render :json => {:status => :already_exists, :errors => @commute.errors}
    end

    def checkout
      @commute = current_employee.commutes.latest.first
      if @commute && @commute.leave == nil
        @commute.leave!
        Attachment.save_for(@commute, current_employee, uploaded_file: params[:file])
        render :json => {:status => :ok, :commute => @commute}
      else
        render :json => {:status => :not_found}
      end
    end
  end
end

# curl "http://mintoffice.dev/api/login.json?account=admin&password=1234"
# curl -F "file=@waldo.jpg;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/commutes/checkin"
# curl -F "file=@waldo.jpg;" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/commutes/checkout"