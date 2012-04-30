class ContactEmailsController < ApplicationController
  expose(:contact)
  expose(:emails) { contact.emails }
  expose(:email)

  def destroy
    email.destroy
    redirect_to contact
  end
end