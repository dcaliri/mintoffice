class Taxman < ActiveRecord::Base
  belongs_to :business_client
  has_many :taxbills

  validates_presence_of :fullname
end