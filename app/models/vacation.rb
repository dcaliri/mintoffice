class Vacation < ActiveRecord::Base
  belongs_to :user
  has_many :used, class_name: 'UsedVacation'

  def remain
    (period - used.total)
  end

  def period
    read_attribute(:period) || 0
  end

  def self.latest
    order('id DESC')
  end
end