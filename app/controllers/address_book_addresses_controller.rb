class AddressBookAddressesController < ApplicationController
  expose(:address_book)
  expose(:addresses) { address_book.addresses }
  expose(:address)

  def destroy
    address.destroy
    redirect_to address_book
  end
end