class ContactsController < ApplicationController
  expose(:contacts) { Contact.all }
  expose(:contact)

  def find
    @target = Hrinfo.find(params[:target])
    @contacts = Contact.search(params[:query])
  end

  def select
    @target = Hrinfo.find(params[:target])
    @contact = Contact.find(params[:id])
    @target.contact = @contact
    @target.save!
  end

  def show
    @attachments = Attachment.for_me(contact, "seq ASC")
    session[:attachments] = [] if session[:attachments].nil?
    @attachments.each { |at| session[:attachments] << at.id }
  end

  def edit
    @attachments = Attachment.for_me(contact, "seq ASC")
  end

  def create
    contact.save!
    Attachment.save_for(contact, @user, params[:attachment])
    redirect_to contact
  end

  def update
    contact.save!
    Attachment.save_for(contact, @user, params[:attachment])
    redirect_to contact
  end

  def destroy
    contact.destroy
    redirect_to contact
  end
end