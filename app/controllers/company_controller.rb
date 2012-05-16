class CompanyController < ApplicationController
  def switch
    company = Company.find(params[:company_id])
    session[:company_id] = company.id
    redirect_to :back
  end
end