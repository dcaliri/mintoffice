class PaymentRecord < ActiveRecord::Base
  has_one :bankbook, as: :holder

  attr_accessor :bankbook_id
  before_save :save_bankook
private
  def save_bankook
    self.bankbook = Bankbook.find(bankbook_id) if bankbook_id
  end
end