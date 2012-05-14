class AddPrivateContact < ActiveRecord::Migration
  class Contact < ActiveRecord::Base
  end

  def change
    add_column :contacts, :user_id, :integer
    add_column :contacts, :private, :boolean, default: false
    Contact.all.each do |contact|
      contact.private = false
      contact.save!
    end
  end
end
