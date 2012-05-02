class MigrateHrinfoTaxmenContentsToContacts < ActiveRecord::Migration
  class Hrinfo < ActiveRecord::Base
  end
  class Taxman < ActiveRecord::Base
  end
  class Contact < ActiveRecord::Base
    belongs_to :target, :polymorphic => true
    has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
    has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
    has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  end

  def up
    add_column :contacts, :migrated_data, :boolean, default: false

    Hrinfo.all.each do |hrinfo|
      contact = Contact.new(migrated_data: true)
      contact.target_type = "Hrinfo"
      contact.target_id = hrinfo.id
      contact.firstname = hrinfo.firstname
      contact.lastname = hrinfo.lastname
      contact.position = hrinfo.position
      contact.emails.build(email: hrinfo.email)
      contact.phone_numbers.build(number: hrinfo.mphone)
      contact.addresses.build(other2: hrinfo.address)
      contact.save!
    end

    Taxman.all.each do |taxman|
      contact = Contact.new(migrated_data: true);
      contact.target_type = "Taxman"
      contact.target_id = taxman.id
      if taxman.fullname
        contact.firstname = taxman.fullname[1..-1]
        contact.lastname = taxman.fullname[0]
      end
      contact.emails.build(email: taxman.email)
      contact.phone_numbers.build(number: taxman.phonenumber)
      contact.save!
    end
  end

  def down
    Contact.where(migrated_data: true).destroy_all
    remove_column :contacts, :migrated_data
  end
end
