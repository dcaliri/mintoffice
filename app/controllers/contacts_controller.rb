class ContactsController < ApplicationController
  expose(:contacts) { Contact.all }
  expose(:contact)

  before_filter :only => [:show] { |c| c.save_attachment_id contact }

  def index
    @contacts = Contact.search(params[:query])
  end

  def find
    @contacts = Contact.search(params[:query])
  end

  def select
    @contact = Contact.find(params[:id])

    target_class = params[:parent_class].blank? ? params[:target_class] : params[:parent_class]
    target_id = params[:parent].blank? ? params[:target] : params[:parent]

    @target = target_class.constantize.find(target_id)

    unless params[:parent_class].blank?
      collections = @target.send(params[:target_class].downcase.pluralize)
      unless params[:target].blank?
        @target = collections.find(params[:target])
      else
        @target = collections.build
      end
    end

    @target.contact = @contact
    @target.save!
  end

  def create
    contact.save!
    redirect_to contact
  end

  def update
    contact.save!
    redirect_to contact
  end

  def destroy
    contact.destroy
    redirect_to contact
  end
end