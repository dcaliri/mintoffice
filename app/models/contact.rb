# encoding: UTF-8

class Contact < ActiveRecord::Base
  belongs_to :target, :polymorphic => true

  REJECT_IF_EMPTY = proc { |attrs| attrs.all? { |k, v| k != "target" ? v.blank? : true  } }

  has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  def self.search(query)
    firstname = "%#{query[0]}%"
    lastname = "%#{query[1..-1]}%"
    query = "%#{query || ""}%"
    where('firstname like ? OR lastname like ? OR firstname like ? OR lastname like ?', firstname, lastname, query, query)
  end

  def name
    if firstname and lastname
      firstname + lastname
    else
      ""
    end
  end
end