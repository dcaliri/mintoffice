# encoding: UTF-8

class Contact < ActiveRecord::Base
  has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end