class AddEnrollmentItemsToCompay < ActiveRecord::Migration
  def change
    add_column :companies, :enrollment_items, :string
  end
end
