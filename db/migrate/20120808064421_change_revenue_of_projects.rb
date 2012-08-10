class ChangeRevenueOfProjects < ActiveRecord::Migration
  def up
  	change_column :projects, :revenue, :decimal, :precision => 20, :scale => 1, :default => 0.0
  end

  def down
  	change_column :projects, :revenue, :decimal, :precision => 20, :scale => 0
  end
end
