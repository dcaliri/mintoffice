class ContactPhoneNumberTagsController < ApplicationController
  expose(:contact_phone_number_tags) { current_company.contact_phone_number_tags }
  expose(:contact_phone_number_tag)

  def new
    session[:return_to] = request.referer
  end

  def create
    contact_phone_number_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end