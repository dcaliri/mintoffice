class PaymentRecord < ActiveRecord::Base
  has_one :payment_request, as: :basis
  has_one :bankbook, as: :holder

  attr_accessor :bankbook_id
  before_save :save_bankook

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, self.amount)
  end

private
  def save_bankook
    unless bankbook_id.blank?
      self.bankbook = Bankbook.find(bankbook_id)
    else
      self.bankbook = nil
    end
  end
end