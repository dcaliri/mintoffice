class PaymentRecord < ActiveRecord::Base
  belongs_to :bankbook
  
  include PaymentRequestable

  class << self
    def search(text, request_status)
      text = "%#{text}%"

      includes(:payment_request).where('payment_records.name LIKE ?', text).search_by_request_status(request_status)
    end
  end


  def generate_payment_request
    PaymentRequest.generate_payment_request(self, bankbook, self.amount)
  end
end