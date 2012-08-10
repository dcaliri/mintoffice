class CreateCompaniesUsers < ActiveRecord::Migration
  def change
    company = Company.find_or_create_by_name("mintech")

    create_table :companies_users, :id => false do |t|
      t.references :company
      t.references :user
    end

    # User.find_each do |user|
    #   user.companies << company
    #   user.save!
    # end
  end
end