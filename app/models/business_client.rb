class BusinessClient < ActiveRecord::Base
  has_many :taxmen
  belongs_to :attachment

  validates_presence_of :name

  self.per_page = 20

  def self.search(text)
    text = "%#{text || ""}%"
    where('name like ? OR registration_number like ? OR category like ? OR condition like ? OR address like ? or owner like ?', text, text, text, text, text, text)
  end
end