class AddSubgroupsOfGroups < ActiveRecord::Migration
  def change
    add_column :groups, :parent_id, :integer
  end
end
