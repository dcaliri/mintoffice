class ContactOtherTag < ActiveRecord::Base
  has_and_belongs_to_many :contact_others
  validates_uniqueness_of :name
end