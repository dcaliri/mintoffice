class ContactEmailTag < ActiveRecord::Base
  has_and_belongs_to_many :contact_emails
  validates_uniqueness_of :name
end