class ContactsController < ApplicationController
  expose(:contacts) { Contact.all }
  expose(:contact)


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