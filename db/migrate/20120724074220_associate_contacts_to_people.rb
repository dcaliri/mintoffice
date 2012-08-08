class AssociateContactsToPeople < ActiveRecord::Migration
  class ::Hrinfo < ActiveRecord::Base
    belongs_to :person
  end

  class ::Person < ActiveRecord::Base
    has_many :hrinfo
  end

  def up
    add_column :contacts, :person_id, :integer

    Contact.find_each do |contact|
      if contact.target_type
        target = contact.target_type.constantize.find_by_id(contact.target_id)
        contact.update_column(:person_id, target.person) if target
      end
    end

    remove_column :contacts, :target_id
    remove_column :contacts, :target_type
  end

  def down
    add_column :contacts, :target_id, :integer
    add_column :contacts, :target_type, :string

    Contact.find_each do |contact|
      person = Person.find_by_id(contact.person_id)
      next unless person

      ["Hrinfo", "Enrollment", "Taxman"].each do |class_name|
        resource = class_name.constantize.find_by_person_id(person.id)
        if resource
          contact.update_column(:target_type, class_name)
          contact.update_column(:target_id, resource.id)
        end
      end
    end

    remove_column :contacts, :person_id
  end
end
