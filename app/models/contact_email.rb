class ContactEmail < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactEmailTag'

  def self.search(query)
    where("email like ?", query)
  end
end