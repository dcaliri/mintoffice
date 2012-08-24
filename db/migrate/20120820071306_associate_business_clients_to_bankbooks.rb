class AssociateBusinessClientsToBankbooks < ActiveRecord::Migration
  def change
    add_column :bankbooks, :holder_type, :string
    add_column :bankbooks, :holder_id, :integer
  end
end
