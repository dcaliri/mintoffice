class ContactAddress < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactAddressTag'
  before_save do
    tag = ContactAddressTag.find_by_name(target)
    tags << tag if tag.present? and !tags.exists?(name: tag.name)
  end

  after_update {|model| model.blank_if_destroy}

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

  def target_view
    target ? "(#{target})" : ""
  end

  def self.search(query)
    where("country like ? OR
          province like ? OR
          city like ? OR
          other1 like ? OR
          other2 like ? OR
          postal_code like ?", query, query, query, query, query, query)
  end


  def serializable_hash(options={})
    super(options.merge(only: [:id, :country, :province, :city, :other1, :other2, :postal_code, :target]))
  end

  def blank_if_destroy
    columns = self.class.column_names
    columns.delete('id')
    columns.delete('contact_id')
    columns.delete('target')
    columns.delete('created_at')
    columns.delete('updated_at')

    attrs = columns.map {|column| send(column)}
    destroy if attrs.all? {|attribute| attribute.blank?}
  end
end