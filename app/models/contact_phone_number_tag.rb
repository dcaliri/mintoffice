class ContactPhoneNumberTag < ActiveRecord::Base
  belongs_to :contact_phone_numbers
  validates_uniqueness_of :name
end