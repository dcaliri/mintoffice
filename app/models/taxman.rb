class Taxman < ActiveRecord::Base
  belongs_to :business_client
  has_many :taxbills

  belongs_to :person
  
  # has_one :contact, :as => :target
  # accepts_nested_attributes_for :contact, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  def contact
    person.contact
  end
  
  include Historiable
  def history_parent
    business_client
  end

  def fullname
    contact.name rescue ""
  end

  def email
    contact.emails.first.email rescue ""
  end

  def phonenumber
    contact.phone_numbers.first.number rescue ""
  end
end