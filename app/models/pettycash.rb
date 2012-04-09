class Pettycash < ActiveRecord::Base
  belongs_to :attachment
  validates_numericality_of :inmoney
  validates_numericality_of :outmoney

  def self.search(text)
  end

  def self.search(query)
    query = "%#{query || ""}%"
    where('description like ?', query)
  end
end
