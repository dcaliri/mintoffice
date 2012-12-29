class Investment < ActiveRecord::Base
  has_many :estimations, class_name: 'InvestmentEstimation'
  accepts_nested_attributes_for :estimations, allow_destroy: true, reject_if: :all_blank

  include Reportable

  def current_estimation
    self.estimations.first
  end

  def initial_estimation
    self.estimations.last
  end

  def self.total_amount
    result = self.all.map{|investment| investment.current_estimation.amount if investment.current_estimation}
    result.delete_if {|amount| amount == nil}
    result.sum
  end
end