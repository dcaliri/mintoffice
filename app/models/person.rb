class Person < ActiveRecord::Base
  has_one :user
  has_one :hrinfo
end