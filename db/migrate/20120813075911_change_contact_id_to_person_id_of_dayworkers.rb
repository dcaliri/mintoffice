class ChangeContactIdToPersonIdOfDayworkers < ActiveRecord::Migration
  class ::Dayworker < ActiveRecord::Base
    belongs_to :person
  end

  class ::Person < ActiveRecord::Base
    has_one :dayworker
  end

  def up
    add_column :dayworkers, :person_id, :integer

    Dayworker.find_each do |dayworker|
      people = Person.create!
      dayworker.update_column(:person_id, people.id)

      contact = Contact.find(dayworker.contact_id)
      contact.update_column(:person_id, people.id)
    end

    remove_column :dayworkers, :contact_id
  end

  def down
    add_column :dayworkers, :contact_id, :integer

    Dayworker.find_each do |dayworker|
      person = Person.find(dayworker.person_id)
      contact = Contact.find_by_person_id(person.id)
      dayworker.update_column(:contact_id, contact.id)

      person.destroy
    end

    remove_column :dayworkers, :person_id
  end
end
