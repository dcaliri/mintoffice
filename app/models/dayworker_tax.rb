class DayworkerTax < ActiveRecord::Base
  has_one :payment_request, as: :basis
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"

  def bankbook
    dayworker.bankbook rescue nil
  end

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, amount)
  end
end