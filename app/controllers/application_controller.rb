# encoding: UTF-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :set_global_current_person_and_company

  def set_global_current_person_and_company
    Person.current_person = current_person
    Company.current_company = current_company
  end

  def current_company
    if session[:company_id].nil?
      session[:company_id] = Company.find_by_name("mintech") || Company.first
    end
    @current_company ||= Company.find(session[:company_id]) unless session[:company_id].nil?
  end
  helper_method :current_company

  def current_person
    @current_person ||= Person.find(session[:person_id]) unless session[:person_id].nil?
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
  def Employee(permission)
    if permission == :protedted and current_employee.admin? == false
      Employee.where(id: current_employee.id)
    else
      Employee.scoped
    end
  end

  def save_attachment_id(resource)
    @attachment_ids ||= []
    resource.attachments.each { |at| @attachment_ids << at.id }
    session[:attachments] = @attachment_ids
  end
end
