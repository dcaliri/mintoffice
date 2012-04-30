class AddEmailListToAddressBooks < ActiveRecord::Migration
  def change
    add_column :address_books, :email_list, :text
  end
end
