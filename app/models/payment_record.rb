class PaymentRecord < ActiveRecord::Base
  has_one :payment_request, as: :basis
  has_one :bankbook, as: :holder

  attr_accessor :bankbook_id
  before_save :save_bankook

  def generate_payment_request
    bankbook = self.bankbook rescue nil
    PaymentRequest.new do |payment_request|
      if bankbook
        payment_request.bank_name = bankbook.number
        payment_request.account_number = bankbook.number
        payment_request.account_holder = bankbook.account_holder
      end
      # payment_request.amount = self.total
      payment_request.basis = self
    end
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