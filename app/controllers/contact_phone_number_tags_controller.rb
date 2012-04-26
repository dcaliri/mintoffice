class ContactPhoneNumberTagsController < ApplicationController
  def new
    session[:return_to] = request.referer
    @contact_tag = ContactPhoneNumberTag.new
  end

  def create
    @contact_tag = ContactPhoneNumberTag.new(params[:contact_phone_number_tag])
    @contact_tag.save!
    redirect_to session[:return_to]
  end
end