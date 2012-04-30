class ContactPhoneNumbersController < ApplicationController
  expose(:contact)
  expose(:phone_numbers) { contact.phone_numbers }
  expose(:phone_number)

  def destroy
    phone_number.destroy
    redirect_to contact
  end
end