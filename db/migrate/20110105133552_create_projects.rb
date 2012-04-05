class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.text :name
      t.date :started_on
      t.date :ending_on
      t.date :ended_on
      t.decimal :revenue, :precision => 20, :scale => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
