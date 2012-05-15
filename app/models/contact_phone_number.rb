class ContactPhoneNumber < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactPhoneNumberTag'
  validates_format_of :number, :with => /\A[0-9\-]+\Z/i

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end
  def history_info
    {
      :number => proc { |number, v| "[#{number.target}]#{v}" }
    }
  end

  def self.search(query)
    where("number like ?", query)
  end
end