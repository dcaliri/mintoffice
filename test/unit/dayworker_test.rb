require 'test_helper'

class DayworkerTest < ActiveSupport::TestCase
	fixtures :dayworkers

  test "dayworker should create dayworker" do
  	dayworker = Dayworker.new
    dayworker.juminno = "new dayworker"
    assert dayworker.save!
  end

  test "dayworker should update dayworker" do
  	dayworker = Dayworker.find(current_dayworker.id)
    dayworker.juminno = "update dayworker"
    assert dayworker.save!
  end

  private
  def current_dayworker
    @dayworker ||= dayworkers(:fixture)
  end
end