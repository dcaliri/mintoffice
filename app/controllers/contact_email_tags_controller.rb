class ContactEmailTagsController < ApplicationController
  expose(:contact_email)

  def new
    @contact_tag = contact_email.tags.build
  end

  def create
    @contact_tag = contact_email.tags.build(params[:contact_email_tag])
    @contact_tag.save!
    redirect_to [:edit, contact_email.contact]
  end
end