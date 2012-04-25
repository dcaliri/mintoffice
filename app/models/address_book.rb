# encoding: UTF-8

class AddressBook < ActiveRecord::Base
  ADDRESS_TARGET = ["", "집", "직장"]
  EMAIL_TARGET = ["", "집", "회사"]
  PHONENUMBER_TARGET = ["", "집", "회사", "핸드폰"]

  has_many :addresses, class_name: 'AddressBookAddress', :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :emails, class_name: 'AddressBookEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :phone_numbers, class_name: 'AddressBookPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end