class AddShortNameToCreditCard < ActiveRecord::Migration
  def change
    add_column :creditcards, :short_name, :string
  end
end