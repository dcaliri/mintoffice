class PaymentRecord < ActiveRecord::Base
  belongs_to :bankbook
  
  include PaymentRequestable

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, bankbook, self.amount)
  end
end