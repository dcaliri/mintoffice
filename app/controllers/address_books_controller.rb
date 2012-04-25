class AddressBooksController < ApplicationController
  expose(:address_books) { AddressBook.all }
  expose(:address_book)


  def create
    address_book.save!
    redirect_to address_book
  end

  def update
    address_book.save!
    redirect_to address_book
  end

  def destroy
    address_book.destroy
    redirect_to address_book
  end
end