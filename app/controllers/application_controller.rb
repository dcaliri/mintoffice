# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authorize, :except => [:login, :logout]
  before_filter :set_global_current_account_and_company
  helper_method :title
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_global_current_account_and_company
    Account.current_account = current_account
    Company.current_company = current_company
  end

  def current_company
    if session[:company_id].nil?
      session[:company_id] = Company.find_by_name("mintech") || Company.first
    end
    @current_company ||= Company.find(session[:company_id]) unless session[:company_id].nil?
  end
  helper_method :current_company

  def current_account
    @current_account ||= Account.find(session[:account_id]) unless session[:account_id].nil?
  end
  helper_method :current_account


  before_filter :modify_query_parameter
  def modify_query_parameter
    [:q, :query].each do |query|
      params[query] = "#{params[query] ? params[query].strip : ""}" unless params[query].blank?
    end
  end

  protected
  def authorize
    @account = current_account
    if @account.nil? or @account.not_joined?
      redirect_to accounts_login_path
      return
    end
    if @account.ingroup? "admin"
      return
    end

    redirect_unless_permission
  end

  def redirect_unless_permission
    unless Permission.can_access? @account, controller_name, action_name
      force_redirect
    end
  end

  def redirect_unless_admin
    force_redirect unless @account.ingroup? "admin"
  end

  def redirect_unless_me(account)
    unless @account.ingroup? "admin"
      force_redirect unless @account == account
    end
  end

  def force_redirect
    flash[:notice] = "You don't have to permission"
    redirect_to :root
  end

  def Account(permission)
    if permission == :protedted && @account.ingroup?(:admin) == false
      Account.where(name: @account.name)
    else
      Account
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
    @attachment_ids ||= []
    resource.attachments.each { |at| @attachment_ids << at.id }
    session[:attachments] = @attachment_ids
  end

  def access_check
    model_name = (controller_name.singularize.classify).constantize
    model = model_name.find(params[:id])
    force_redirect unless model.access?(current_account)
  end
end
