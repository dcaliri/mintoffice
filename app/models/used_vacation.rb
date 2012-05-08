class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  include Historiable
  def parent
    vacation
  end

  def self.total
    all.sum {|vacation| vacation.period || 0}
  end
end