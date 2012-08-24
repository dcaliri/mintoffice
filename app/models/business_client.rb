class BusinessClient < ActiveRecord::Base
  belongs_to :company

  has_many :taxmen, dependent: :destroy
  accepts_nested_attributes_for :taxmen, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  has_one :bankbook, as: :holder

  validates_presence_of :name

  include Historiable
  include Attachmentable

  self.per_page = 20

  attr_accessor :bankbook_id
  before_save :save_bankook

  def self.search(text)
    text = "%#{text}%"
    where('name like ? OR registration_number like ? OR category like ? OR business_status like ? OR address like ? or owner like ?', text, text, text, text, text, text)
  end

private
  def save_bankook
    unless bankbook_id.blank?
      self.bankbook = Bankbook.find(bankbook_id)
    else
      self.bankbook = nil
    end
  end
end