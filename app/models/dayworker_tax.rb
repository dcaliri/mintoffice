class DayworkerTax < ActiveRecord::Base
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"

  include PaymentRequestable

  def generate_payment_request
    bankbook = dayworker.bankbook rescue nil
    PaymentRequest.generate_payment_request(self, bankbook, pay_amount)
  end
end