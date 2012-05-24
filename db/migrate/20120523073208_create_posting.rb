class CreatePosting < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.date :posted_at
      t.text :description
      t.timestamps
    end
  end
end
