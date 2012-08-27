require 'test_helper'

class InvestmentTest < ActiveSupport::TestCase
	fixtures :investments

  test "investment should create investment" do
  	investment = Investment.new
    investment.title = "new title"
    investment.description = "new description"
    assert investment.save!
  end

  test "investment should update investment" do
  	investment = Investment.find(current_investment.id)
    investment.title = "update title"
    investment.description = "update description"
    assert investment.save!
  end

  test "investment should destroy investment" do
  	investment = Investment.find(current_investment.id)
    assert investment.destroy
  end

  private
  def current_investment
    @investment ||= investments(:fixture)
  end
end