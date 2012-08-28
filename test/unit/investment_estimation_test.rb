require 'test_helper'

class InvestmentEstimationTest < ActiveSupport::TestCase
  fixtures :investments
	fixtures :investment_estimations

  test "investment_estimation should create investment_estimation" do
  	investment_estimation = InvestmentEstimation.new
    investment_estimation.investment_id = current_investment.id
    investment_estimation.amount = 20300
    investment_estimation.estimated_at = Time.zone.now
    assert investment_estimation.save!
  end

  test "investment_estimation should update investment_estimation" do
  	investment_estimation = InvestmentEstimation.find(current_investment_estimation.id)
    investment_estimation.amount = 34589800
    investment_estimation.estimated_at = Time.zone.now
    assert investment_estimation.save!
  end

  test "investment_estimation should destroy investment_estimation" do
  	investment_estimation = InvestmentEstimation.find(current_investment_estimation.id)
    assert investment_estimation.destroy
  end

  private
  def current_investment
    @investment ||= investments(:fixture)
  end

  def current_investment_estimation
    @investment_estimation ||= investment_estimations(:fixture)
  end
end