class BusinessClient < ActiveRecord::Base
  has_many :taxmen
  validates_presence_of :name

  self.per_page = 20
end