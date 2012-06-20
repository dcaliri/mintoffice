class ContactPhoneNumber < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactPhoneNumberTag'
  validates_format_of :number, :with => /\A[0-9\-]+\Z/i, :allow_blank => true
  after_update {|model| model.destroy if model.number.blank?}
  before_save do
    tag = ContactPhoneNumberTag.find_by_name(target)
    tags << tag if tag.present? and !tags.exists?(name: tag.name)
  end

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

  def serializable_hash(options={})
    super(options.merge(only: [:id, :number, :target]))
  end
end