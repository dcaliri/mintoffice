class ContactEmailTagsController < ApplicationController
  expose(:contact_email_tags) { current_company.contact_email_tags }
  expose(:contact_email_tag)

  def new
    session[:return_to] = request.referer
  end

  def create
    contact_email_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end