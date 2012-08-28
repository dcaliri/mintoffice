class InvestmentEstimation < ActiveRecord::Base
  default_scope order('estimated_at DESC')

  belongs_to :investment
end