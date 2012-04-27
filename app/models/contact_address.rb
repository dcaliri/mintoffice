class ContactAddress < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactAddressTag'

  def info
    [country, province, city, other1, other2, postal_code].join(" ")
  end
end