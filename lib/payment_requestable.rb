# encoding: UTF-8

module PaymentRequestable
  extend ActiveSupport::Concern

  def request_status
    unless payment_request
      "청구전"
    else
      payment_request.request_status
    end
  end

  included do
    has_one :payment_request, as: :basis
  end
end