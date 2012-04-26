class Taxman < ActiveRecord::Base
  belongs_to :business_client
  has_many :taxbills
  has_one :contact, :as => :target

  def fullname
    read_attribute(:fullname) || contact.name
  end

  def email
    read_attribute(:email) || contact.emails.first.email
  end

  def phonenumber
    read_attribute(:phonenumber) || contact.phone_numbers.first.number
  end
end