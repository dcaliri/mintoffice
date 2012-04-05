class CreateNamecards < ActiveRecord::Migration
  def self.up
    create_table :namecards do |t|
      t.string :name
      t.string :jobtitle
      t.string :department
      t.string :company
      t.string :phone
      t.string :homepage
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :namecards
  end
end
