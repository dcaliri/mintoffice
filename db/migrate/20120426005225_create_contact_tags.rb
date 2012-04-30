class CreateContactTags < ActiveRecord::Migration
  def change
    [:address, :email, :phone_number].each do |tag|
      create_table "contact_#{tag}_tags".to_sym do |t|
        t.string :name
        t.timestamps
      end

      create_table "contact_#{tag}_tags_contact_#{tag.to_s.pluralize}".to_sym, :id => false do |t|
        t.references "contact_#{tag}_tag", "contact_#{tag}"
      end
    end
  end
end
