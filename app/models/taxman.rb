class Taxman < ActiveRecord::Base
  belongs_to :business_client

  validates_presence_of :fullname
end