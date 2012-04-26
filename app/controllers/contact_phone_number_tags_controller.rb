class ContactPhoneNumberTagsController < ApplicationController
  expose(:contact_phone_number)

  def new
    @contact_tag = contact_phone_number.tags.build
  end

  def create
    @contact_tag = contact_phone_number.tags.build(params[:contact_phone_number_tag])
    @contact_tag.save!
    redirect_to [:edit, contact_phone_number.contact]
  end
end