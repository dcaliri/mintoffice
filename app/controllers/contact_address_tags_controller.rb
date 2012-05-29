class ContactAddressTagsController < ApplicationController
  expose(:contact_address_tags) { current_company.contact_address_tags }
  expose(:contact_address_tag)

  def new
    session[:return_to] = request.referer
    # @contact_tag = ContactAddressTag.new
    @contact_tag = contact_address_tag
  end

  def create
    # @contact_tag = ContactAddressTag.new(params[:contact_address_tag])
    # @contact_tag.save!
    contact_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  private
  def find_contact_address
    @address = ContactAddress.find(params[:contact_address_id])
  end

end