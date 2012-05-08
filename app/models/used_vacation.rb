#encoding: UTF-8

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  include Historiable
  def history_parent
    vacation
  end
  def history_info
    {
      from: proc { |used, v| "[사용 연차]#{v}" },
      to: proc { |used, v| "[사용 연차]#{v}" }
    }
  end

  def self.total
    all.sum {|vacation| vacation.period || 0}
  end
end