class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  def self.total
    all.sum {|vacation| vacation.period}
  end
end