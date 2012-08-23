require 'test_helper'

class PromissoryTest < ActiveSupport::TestCase
	fixtures :promissories

  test "Promissory should create promissory" do
  	promissory = Promissory.new
    promissory.expired_at = Time.zone.now
    promissory.published_at = Time.zone.now
    promissory.amount = 10000
    assert promissory.save!
  end

  test "Promissory should update promissory" do
  	promissory = Promissory.find(current_promissory.id)
    promissory.amount = 5000000
    assert promissory.save!
  end

  test "Promissory should destroy promissory" do
  	promissory = Promissory.find(current_promissory.id)
    assert promissory.destroy
  end

  private
  def current_promissory
    @promissory ||= promissories(:fixture)
  end
end