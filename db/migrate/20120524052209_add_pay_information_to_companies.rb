class AddPayInformationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :pay_basic_date, :integer, default: 20
    add_column :companies, :payday, :integer, default: 25
  end
end
