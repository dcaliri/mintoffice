class Taxman < ActiveRecord::Base
  belongs_to :business_client
  has_many :taxbills
  has_one :contact, :as => :target

  def fullname
    contact.name
    # contact ? contact.name : read_attribute(:fullname)
  end

  def email
    contact.emails.first.email
    # contact ? contact.emails.first.email : read_attribute(:email)
  end

  def phonenumber
    contact.phone_numbers.first.number
    # contact ? contact.phone_numbers.first.number : read_attribute(:phonenumber)
  end
end