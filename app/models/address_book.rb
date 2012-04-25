class AddressBook < ActiveRecord::Base
  has_many :emails, class_name: 'AddressBookEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :phone_numbers, class_name: 'AddressBookPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end