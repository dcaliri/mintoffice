class SwapFirstnameAndLastnameOfTaxmansContacts < ActiveRecord::Migration
  class Contact < ActiveRecord::Base
    belongs_to :target, :polymorphic => true
    has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
    has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
    has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  end

  def swap
    Contact.where(target_type: "Taxman").each do |contact|
      contact.firstname, contact.lastname = contact.lastname, contact.firstname if contact.target_type == "Taxman"
      contact.save!
    end
  end

  def up
    swap
  end

  def down
    swap
  end
end
