# encoding: UTF-8
require 'test_helper'

class PettycashTest < ActiveSupport::TestCase
  fixtures :pettycashes

  setup do
    @valid_attributes = {
      transdate: "#{Time.zone.now}",
      inmoney: 50000,
      outmoney: 50000,
      description: "test",
      attachment_id: nil
    }
  end

  test "Pettycash should create pettycash with valid attributes" do
    pettycash = Pettycash.new(@valid_attributes)
    assert pettycash.valid?
  end

  test "Pettycash shouldn't create pettycash with invalid attributes" do
    pettycash = Pettycash.new(@valid_attributes)
    pettycash.inmoney = "none_numericality"
    assert pettycash.invalid?

    pettycash = Pettycash.new(@valid_attributes)
    pettycash.outmoney = "none_numericality"
    assert pettycash.invalid?
  end
end