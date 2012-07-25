class Vacation < ActiveRecord::Base
  # belongs_to :account
  belongs_to :employee
  has_many :used, class_name: 'UsedVacation'

  include Historiable

  def remain
    (period - used.total)
  end

  def period
    read_attribute(:period) || 0
  end

  def self.latest
    order('id DESC')
  end

  def current?
    Time.zone.now.between?(from, to)
  end
end