# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :set_global_current_account_and_company

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
    @account ||= @current_account ||= Account.find(session[:account_id]) unless session[:account_id].nil?
    # @current_account ||= Account.find(session[:account_id]) unless session[:account_id].nil?
  end
  helper_method :current_account

  def current_person
    current_account.person if current_account
  end
  helper_method :current_person

  def current_employee
    current_person.employee if current_person
  end
  helper_method :current_employee

  include ActionController::Extensions::Parameter
  include ActionController::Extensions::Title
  include ActionController::Extensions::AuthorizeAndAccess

  protected
  def Account(permission)
    if permission == :protedted && current_account.ingroup?(:admin) == false
      Account.where(name: current_account.name)
    else
      Account
    end
  end

  def save_attachment_id(resource)
    @attachment_ids ||= []
    resource.attachments.each { |at| @attachment_ids << at.id }
    session[:attachments] = @attachment_ids
  end
end
