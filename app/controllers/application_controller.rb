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

  before_filter do |controller|
    User.current_user = User.find(controller.session[:user_id]) unless controller.session[:user_id].nil?
  end

  def current_company
    if session[:company_id].nil?
      session[:company_id] = Company.first
    end

    Company.find(session[:company_id]) unless session[:company_id].nil?
  end
  helper_method :current_company

  def current_user
    User.find(session[:user_id]) unless session[:user_id].nil?
  end
  helper_method :current_user


  before_filter :modify_query_parameter
  def modify_query_parameter
    [:q, :query].each do |query|
      params[query] = "#{params[query] ? params[query].strip : ""}" unless params[query].blank?
    end
  end

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

  def redirect_unless_me(user)
    unless @user.ingroup? "admin"
      force_redirect unless @user == user
    end
  end

  def force_redirect
    flash[:notice] = "You don't have to permission"
    redirect_to :controller => 'main', :action => 'index'
  end

  def User(permission)
    if permission == :protedted && @user.ingroup?(:admin) == false
      User.where(name: @user.name)
    else
      User
    end
  end

  def title(text="")
    unless text.blank?
      @title = text
    else
      @title || t("#{controller_name}.title")
    end
  end

  def save_attachment_id(resource)
    session[:attachments] = [] if session[:attachments].nil?
    resource.attachments.each { |at| session[:attachments] << at.id }
  end

  def access_check
    model_name = (controller_name.singularize.classify).constantize
    model = model_name.find(params[:id])
    force_redirect unless model.access?(current_user)
  end
end
