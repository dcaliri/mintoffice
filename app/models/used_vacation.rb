#encoding: UTF-8

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation
  validate :valid_period

  include Historiable
  def history_parent
    vacation
  end

  include Reportable
  def redirect_when_reported
    [vacation, self]
  end

  def valid_period
    errors.add(:period, "1 or 0.5") unless period - period.to_i == 0 || period - period.to_i == 0.5
  end

  def self.total
    all.sum {|vacation| vacation.period || 0}
  end
  
  def self.during(range)
    r = range.begin.to_date..range.end.to_date
    where("`used_vacations`.from IN (?) OR `used_vacations`.to IN (?)", r, r)
  end
  
  def in? (day)
    self.from <=  day && self.to >= day
  end
end
