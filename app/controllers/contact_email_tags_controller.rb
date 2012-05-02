class ContactEmailTagsController < ApplicationController
  def new
    session[:return_to] = request.referer
    @contact_tag = ContactEmailTag.new
  end

  def create
    @contact_tag = ContactEmailTag.new(params[:contact_email_tag])
    @contact_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end