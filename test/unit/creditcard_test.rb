# encoding: UTF-8
require 'test_helper'

class CreditcardTest < ActiveSupport::TestCase
  fixtures :creditcards

  setup do
    @valid_attributes = {
      cardno: "111-111-1111",
      expireyear: "2013",
      expiremonth: "07",
      nickname: "식대카드",
      issuer: "신한은행",
      cardholder: "김 관리",
      short_name: "결재용",
      bank_account_id: 1
    }
  end

  test "ContactPhoneNumber should create contact_phone_number_tag with valid attributes" do
    creditcard = Creditcard.new(@valid_attributes)
    assert creditcard.valid?
  end

  test "ContactPhoneNumber shouldn't create contact_phone_number_tag with invalid attributes" do
    creditcard = Creditcard.new(@valid_attributes)
    creditcard.cardno = nil
    assert creditcard.invalid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.expireyear = nil
    assert creditcard.invalid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.expiremonth = nil
    assert creditcard.invalid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.nickname = nil
    assert creditcard.invalid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.cardholder = nil
    assert creditcard.invalid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.short_name = nil
    assert creditcard.valid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.bank_account_id = nil
    assert creditcard.valid?

    creditcard = Creditcard.new(@valid_attributes)
    creditcard.cardno = "321-321-1234"
    assert creditcard.invalid?
  end
end