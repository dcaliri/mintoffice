class DayworkerTax < ActiveRecord::Base
  has_one :payment_request, as: :basis
  belongs_to :dayworker, :class_name => "Dayworker", :foreign_key => "dayworker_id"

  def generate_payment_request
    bankbook = self.dayworker.bankbook rescue nil
    PaymentRequest.new do |payment_request|
      if bankbook
        payment_request.bank_name = bankbook.number
        payment_request.account_number = bankbook.number
        payment_request.account_holder = bankbook.account_holder
      end
      payment_request.amount = self.amount
      payment_request.basis = self
    end
  end
end