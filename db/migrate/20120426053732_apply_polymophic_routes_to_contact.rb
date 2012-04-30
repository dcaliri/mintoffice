class ApplyPolymophicRoutesToContact < ActiveRecord::Migration
  def change
    rename_column :contacts, :hrinfo_id, :target_id
    add_column :contacts, :target_type, :string
  end
end
