class AddressBookEmailsController < ApplicationController
  expose(:address_book)
  expose(:emails) { address_book.emails }
  expose(:email)

  def destroy
    email.destroy
    redirect_to address_book
  end
end