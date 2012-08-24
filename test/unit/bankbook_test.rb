require 'test_helper'

class BankBookTest < ActiveSupport::TestCase
	fixtures :bankbooks

  test "Bankbook should create bankbook" do
  	bankbook = Bankbook.new
    bankbook.name = "unit bankbook"
    bankbook.number = "111-11111-111"
    bankbook.account_holder = "kim unit"
    assert bankbook.save!
  end

  test "Bankbook should update bankbook" do
  	bankbook = Bankbook.find(current_bankbook.id)
    bankbook.name = "update bankbook"
    bankbook.number = "111-22222-111"
    bankbook.account_holder = "kim update"
    assert bankbook.save!
  end

  test "Bankbook should destroy bankbook" do
  	bankbook = Bankbook.find(current_bankbook.id)
    assert bankbook.destroy
  end

  private
  def current_bankbook
    @bankbook ||= bankbooks(:shinhan)
  end
end