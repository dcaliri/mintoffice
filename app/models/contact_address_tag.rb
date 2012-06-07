class ContactAddressTag < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :contact_addresses
  validates_uniqueness_of :name, scope: :company_id
end