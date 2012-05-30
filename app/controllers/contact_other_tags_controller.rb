class ContactOtherTagsController < ApplicationController
  expose(:contact_other_tags) { current_company.contact_other_tags }
  expose(:contact_other_tag)

  def new
    session[:return_to] = request.referer
  end

  def create
    contact_other_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end