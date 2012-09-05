class ContactOther < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactOtherTag'

  after_update {|model| model.blank_if_destroy}

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end
  def history_info
    {
      :description => proc { |other, v| "[#{other.target}]#{v}" }
    }
  end

  def target_view
    target ? "(#{target})" : ""
  end

  def self.search(query)
    where("description like ?", query)
  end

  def all_blank?
    description.blank?
  end

  def blank_if_destroy
    destroy if all_blank?
  end
end