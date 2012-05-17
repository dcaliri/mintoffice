class Company < ActiveRecord::Base
  has_many :projects
  has_many :documents
  has_many :business_clients
  has_many :contacts
end