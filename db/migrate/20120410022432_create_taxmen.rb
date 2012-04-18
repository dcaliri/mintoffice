class CreateTaxmen < ActiveRecord::Migration
  def change
    create_table :taxmen do |t|
      t.references :business_client
      t.string :fullname
      t.string :email
      t.string :phonenumber
      t.timestamps
    end
  end
end
