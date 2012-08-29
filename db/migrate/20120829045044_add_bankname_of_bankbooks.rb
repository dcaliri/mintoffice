class AddBanknameOfBankbooks < ActiveRecord::Migration
  def change
    add_column :bankbooks, :bankname, :string
  end
end
