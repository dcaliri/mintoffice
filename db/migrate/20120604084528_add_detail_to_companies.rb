class AddDetailToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :registration_number, :string
    add_column :companies, :owner_name, :string
    add_column :companies, :address, :string
    add_column :companies, :phone_number, :string
  end
end
