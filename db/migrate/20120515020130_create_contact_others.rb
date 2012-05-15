class CreateContactOthers < ActiveRecord::Migration
  def change
    create_table :contact_others do |t|
      t.references :contact
      t.string :target
      t.string :description
      t.timestamps
    end

    create_table :contact_other_tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :contact_other_tags_contact_others, :id => false do |t|
      t.references :contact_other_tag, :contact_other
    end
  end
end
