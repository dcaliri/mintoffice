class CreateAddressBookEmails < ActiveRecord::Migration
  def change
    create_table :address_book_emails do |t|
      t.references :address_book
      t.string :target
      t.string :email
    end
  end
end
