class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create auth = request.env["omniauth.auth"]
#    render :text => auth.to_xml
    user = User.find_or_create_with_omniauth!(auth)
    if user
      session[:user_id] = user.id
      redirect_to :root, :notice => "Successfully Signed in!"
    else
      redirect_to users_login_path(), :notice => "Not Registered"
    end
  end
end