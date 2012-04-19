# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authorize, :except => [:login, :logout]
  helper_method :title
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

    redirect_unless_permission
  end

  def redirect_unless_permission
    unless Permission.can_access? @user, controller_name, action_name
      force_redirect
    end
  end

  def redirect_unless_admin
    force_redirect unless @user.ingroup? "admin"
  end

  def redirect_unless_me
    unless @user.ingroup?(:admin)
      force_redirect if @user.id != params[:id].to_i
    end
  end

  def force_redirect
    flash[:notice] = "You don't have to permission"
    redirect_to :controller => 'main', :action => 'index'
  end

  def title(text="")
    unless text.blank?
      @title = text
    else
      @title || t("#{controller_name}.#{action_name}.title")
    end
  end
end
