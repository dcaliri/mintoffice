class CreateAdressBookAddresses < ActiveRecord::Migration
  def change
    create_table :address_book_addresses do |t|
      t.references :address_book
      t.string :target
      t.string :country
      t.string :province
      t.string :city
      t.string :other1
      t.string :other2
      t.string :postal_code
      t.timestamps
    end
  end
end
