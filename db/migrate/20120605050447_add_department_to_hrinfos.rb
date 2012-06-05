class AddDepartmentToHrinfos < ActiveRecord::Migration
  def change
    add_column :hrinfos, :department, :string
  end
end
