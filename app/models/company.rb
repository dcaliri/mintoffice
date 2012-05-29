class Company < ActiveRecord::Base
  has_many :projects
  has_many :documents
  has_many :business_clients
  has_many :contacts
  has_many :contact_address_tags
  has_many :contact_email_tags
  has_many :contact_phone_number_tags
  has_many :contact_other_tags
end