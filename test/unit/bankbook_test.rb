# encoding: UTF-8
require 'test_helper'

class BankBookTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: "기본 통장",
      number: "100-100-100010",
      account_holder: "김 개똥",
      bankname: "기본 은행"
    }
  end

  test "Bankbook should create bankbook with valid attributes" do
    bankbook = Bankbook.new(@valid_attributes)
    assert bankbook.valid?
  end

  test "Bankbook shouldn't create bankbook with invalid attributes" do
    bankbook = Bankbook.new(@valid_attributes)
    bankbook.name = nil
    assert bankbook.invalid?

    bankbook = Bankbook.new(@valid_attributes)
    bankbook.number = nil
    assert bankbook.invalid?

    bankbook = Bankbook.new(@valid_attributes)
    bankbook.account_holder = nil
    assert bankbook.invalid?

    bankbook = Bankbook.new(@valid_attributes)
    bankbook.bankname = nil
    assert bankbook.valid?
  end
end