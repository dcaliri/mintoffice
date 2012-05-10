class Pettycash < ActiveRecord::Base
  validates_numericality_of :inmoney
  validates_numericality_of :outmoney

  include Historiable
  include Attachmentable

  def self.search(text)
    text = "%#{text}%"
    where('description like ?', text)
  end
end
