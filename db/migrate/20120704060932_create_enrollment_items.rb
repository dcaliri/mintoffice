class CreateEnrollmentItems < ActiveRecord::Migration
  def change
    create_table :enrollment_items do |t|
      t.string :name
      t.integer :enrollment_id
      t.timestamps
    end
  end
end
