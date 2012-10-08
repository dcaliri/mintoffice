class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :title
      t.text   :description
      t.timestamps
    end
  end
end
