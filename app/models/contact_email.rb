class ContactEmail < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactEmailTag'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end
  def history_info
    {
      :email => proc { |email, v| "[#{email.target}]#{v}" }
    }
  end

  def self.search(query)
    where("email like ?", query)
  end
end