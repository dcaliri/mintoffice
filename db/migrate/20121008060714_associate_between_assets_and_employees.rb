class AssociateBetweenAssetsAndEmployees < ActiveRecord::Migration
  def change
    add_column :assets, :owner_id, :integer
  end
end
