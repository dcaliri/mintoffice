class BusinessClient < ActiveRecord::Base
  has_many :taxmen
  belongs_to :attachment

  validates_presence_of :name

  self.per_page = 20
end