class ContactOthersController < ApplicationController
  expose(:contact)
  expose(:others) { contact.others }
  expose(:other)

  def destroy
    other.destroy
    redirect_to contact
  end
end