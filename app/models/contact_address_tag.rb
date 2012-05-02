class ContactAddressTag < ActiveRecord::Base
  has_and_belongs_to_many :contact_addresses
  validates_uniqueness_of :name
end