class ContactPhoneNumberTag < ActiveRecord::Base
  belongs_to :company
  belongs_to :contact_phone_numbers
  validates_uniqueness_of :name, scope: :company_id
end