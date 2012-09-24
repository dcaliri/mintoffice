class PaymentRecord < ActiveRecord::Base
  has_one :payment_request, as: :basis
  belongs_to :bankbook

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, self.amount)
  end
end