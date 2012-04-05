class CreateRequiredTags < ActiveRecord::Migration
  def self.up
    create_table :required_tags do |t|
      t.string :modelname
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :required_tags
  end
end
