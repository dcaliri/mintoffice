class ContactsController < ApplicationController
  expose(:contacts) { Contact.all }
  expose(:contact)

  def find
    @contacts = Contact.search(params[:query])
  end

  def select
    @contact = Contact.find(params[:id])

    target_class = params[:parent_class] || params[:target_class]
    target_id = params[:parent] || params[:target]

    @target = target_class.constantize.find(target_id)

    if params[:parent_class]
      collections = @target.send(params[:target_class].downcase.pluralize)
      if params[:target]
        @target = collections.find(params[:target])
      else
        @target = collections.build
      end
    end

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