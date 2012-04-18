class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  def self.total
    all.sum {|vacation| vacation.period || 0}
  end
end