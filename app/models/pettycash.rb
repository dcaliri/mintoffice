class Pettycash < ActiveRecord::Base
  default_scope order('transdate desc')
  validates_numericality_of :inmoney
  validates_numericality_of :outmoney

  self.per_page = 20

  include Historiable
  include Attachmentable

  def self.search(text)
    text = "%#{text}%"
    where('description like ?', text)
  end
end
