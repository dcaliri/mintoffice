class CreateAddressBooks < ActiveRecord::Migration
  def change
    create_table :address_books do |t|
      t.string :firstname
      t.string :lastname
      t.string :company
      t.string :department
      t.string :position
    end
  end
end
