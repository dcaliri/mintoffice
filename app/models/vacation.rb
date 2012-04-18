class Vacation < ActiveRecord::Base
  belongs_to :user
  has_many :used, class_name: 'UsedVacation'

  def remain
    (period - used.total)
  end
end