class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create auth = request.env["omniauth.auth"]
#    render :text => auth.to_xml
    user = User.find_or_create_with_omniauth!(auth)
    session[:user_id] = user.id
    redirect_to :root, :notice => "Successfully Signed in!"
  end
end