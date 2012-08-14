class RenameHrinfosToEmployees < ActiveRecord::Migration
  def change
    rename_table :hrinfos, :employees
  end
end
