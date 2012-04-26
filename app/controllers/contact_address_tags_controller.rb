class ContactAddressTagsController < ApplicationController
  before_filter :find_contact_address

  def new
    @contact_tag = @address.tags.build
  end

  def create
    @contact_tag = @address.tags.build(params[:contact_address_tag])
    @contact_tag.save!
    redirect_to [:edit, @address.contact]
  end

  private
  def find_contact_address
    @address = ContactAddress.find(params[:contact_address_id])
  end

end