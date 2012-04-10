class BusinessClient < ActiveRecord::Base
  validates_presence_of :name

  self.per_page = 20
end