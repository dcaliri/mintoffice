class ContactAddress < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactAddressTag'
  before_save do
    tag = ContactAddressTag.find_by_name(target)
    tags << tag if tag.present? and tags.empty?(name: tag.name)
  end

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end


  def info
    [country, province, city, other1, other2, postal_code].join(" ")
  end

  def self.search(query)
    where("country like ? OR
          province like ? OR
          city like ? OR
          other1 like ? OR
          other2 like ? OR
          postal_code like ?", query, query, query, query, query, query)
  end
end