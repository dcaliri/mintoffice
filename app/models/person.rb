class Person < ActiveRecord::Base
  has_one :user

  has_one :hrinfo
  has_one :enrollment

  has_many :reporters, class_name: 'ReportPerson'
  has_many :accessors, class_name: 'AccessPerson'
end