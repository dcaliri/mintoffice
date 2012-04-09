class Pettycash < ActiveRecord::Base
  belongs_to :attachment
  validates_numericality_of :inmoney
  validates_numericality_of :outmoney

  def self.search(text)
    text = "%#{text || ""}%"
    where('description like ?', text)
  end
end
