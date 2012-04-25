class AddressBookPhoneNumbersController < ApplicationController
  expose(:address_book)
  expose(:phone_numbers) { address_book.phone_numbers }
  expose(:phone_number)

  def destroy
    phone_number.destroy
    redirect_to address_book
  end
end