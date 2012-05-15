class ContactOtherTagsController < ApplicationController
  def new
    session[:return_to] = request.referer
    @contact_tag = ContactOtherTag.new
  end

  def create
    @contact_tag = ContactOtherTag.new(params[:contact_other_tag])
    @contact_tag.save!
    redirect_to session[:return_to]
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end