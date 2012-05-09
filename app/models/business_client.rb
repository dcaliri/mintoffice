class BusinessClient < ActiveRecord::Base
  has_many :taxmen
  accepts_nested_attributes_for :taxmen, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_many :attachments, :as => :owner
  accepts_nested_attributes_for :attachments

  validates_presence_of :name

  include Historiable

  self.per_page = 20

  def self.search(text)
    text = "%#{text || ""}%"
    where('name like ? OR registration_number like ? OR category like ? OR condition like ? OR address like ? or owner like ?', text, text, text, text, text, text)
  end
end