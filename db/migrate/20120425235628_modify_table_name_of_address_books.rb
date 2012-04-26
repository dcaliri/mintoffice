class ModifyTableNameOfAddressBooks < ActiveRecord::Migration
  def change
    rename_table :address_books, :contacts
    rename_table :address_book_emails, :contact_emails
    rename_table :address_book_phone_numbers, :contact_phone_numbers
    rename_table :address_book_addresses, :contact_addresses

    rename_column :contact_emails, :address_book_id, :contact_id
    rename_column :contact_phone_numbers, :address_book_id, :contact_id
    rename_column :contact_addresses, :address_book_id, :contact_id
  end
end
