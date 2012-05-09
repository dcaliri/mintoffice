class Pettycash < ActiveRecord::Base
  has_many :attachments, :as => :owner
  accepts_nested_attributes_for :attachments

  validates_numericality_of :inmoney
  validates_numericality_of :outmoney

  include Historiable

  def self.search(text)
    text = "%#{text || ""}%"
    where('description like ?', text)
  end
end
