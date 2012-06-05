class CompaniesController < ApplicationController
  before_filter :redirect_unless_current_company
  expose(:company)

  before_filter :only => [:show] {|c| c.save_attachment_id company}

  def switch
    company = Company.find(params[:company_id])
    session[:company_id] = company.id
    redirect_to :back
  end

  def update
    company.save!
    redirect_to company
  rescue ActiveRecord::RecordInvalid
    render "edit"
  end

  private
  def redirect_unless_current_company
    force_redirect unless company == current_company
  end
end