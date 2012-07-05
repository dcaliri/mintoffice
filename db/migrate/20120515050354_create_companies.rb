class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.timestamps
    end
    Company.create!(name: "mintech")
  end
end
