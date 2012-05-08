class ContactPhoneNumber < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactPhoneNumberTag'

  include Historiable
  def parent
    contact
  end

  def self.search(query)
    where("number like ?", query)
  end
end