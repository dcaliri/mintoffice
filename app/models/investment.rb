class Investment < ActiveRecord::Base
  has_many :estimations, class_name: 'InvestmentEstimation'
  accepts_nested_attributes_for :estimations, allow_destroy: true, reject_if: :all_blank

  def current_estimation
    self.estimations.first
  end

  def initial_estimation
    self.estimations.last
  end
end