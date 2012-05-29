class ContactAddressTagsController < ApplicationController
  expose(:contact_address_tags) { current_company.contact_address_tags }
  expose(:contact_address_tag)

  def new
    session[:return_to] = request.referer
  end

  def create
    contact_address_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  private
end