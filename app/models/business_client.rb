class BusinessClient < ActiveRecord::Base
  belongs_to :company

  has_many :taxmen, dependent: :destroy
  accepts_nested_attributes_for :taxmen, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :name

  include Historiable
  include Attachmentable
  include Bankbookable

  self.per_page = 20

  def self.search(text)
    text = "%#{text}%"
    where('name like ? OR registration_number like ? OR category like ? OR business_status like ? OR address like ? or owner like ?', text, text, text, text, text, text)
  end
end