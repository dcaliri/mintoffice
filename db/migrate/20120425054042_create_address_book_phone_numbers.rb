class CreateAddressBookPhoneNumbers < ActiveRecord::Migration
  def change
    create_table :address_book_phone_numbers do |t|
      t.references :address_book
      t.string :target
      t.string :number
    end
  end
end
