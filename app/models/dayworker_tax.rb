class DayworkerTax < ActiveRecord::Base
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"

  include PaymentRequestable

  def bankbook
    dayworker.bankbook rescue nil
  end

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, pay_amount)
  end
end