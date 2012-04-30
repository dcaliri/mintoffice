class ContactAddressesController < ApplicationController
  expose(:contact)
  expose(:addresses) { contact.addresses }
  expose(:address)

  def destroy
    address.destroy
    redirect_to contact
  end
end