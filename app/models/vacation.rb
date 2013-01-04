class Vacation < ActiveRecord::Base
  belongs_to :employee
  has_many :used, class_name: 'UsedVacation'

  include Historiable

  class << self
    def latest
      order('id DESC')
    end

    def include_today
      today = Date.today
      where('`vacations`.`from` <= ?', today).where('`vacations`.`to` > ?', today)
    end

  end

  def remain
    (period - used.total)
  end

  def period
    read_attribute(:period) || 0
  end

  def current?
    Time.zone.now.between?(from, to)
  end
end