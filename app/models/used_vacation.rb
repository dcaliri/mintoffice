#encoding: UTF-8

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation
  validate :valid_period
  
  include Historiable
  def history_parent
    vacation
  end

  def valid_period
    errors.add(:period, "1 or 0.5") unless period - period.to_i == 0 || period - period.to_i == 0.5
  end
  
  def self.total
    all.sum {|vacation| vacation.period || 0}
  end
end
