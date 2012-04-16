# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authorize, :except => [:login, :logout]
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected
  def authorize
    @user = User.find(session[:user_id]) if session[:user_id]
    unless @user
      redirect_to users_login_path
      return
    end
    if @user.ingroup? "admin"
      return
    end

    unless Permission.can_access? @user, controller_name, action_name
      flash[:notice] = "You don't have to permission"
      redirect_to :controller => 'main', :action => 'index'
    end
  end
end
