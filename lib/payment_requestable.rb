# encoding: UTF-8

module PaymentRequestable
  extend ActiveSupport::Concern

  module ClassMethods
    def search_by_request_status(status)
      status ||= "all"
      status = status.to_sym
      case status
      when :not_created
        scoped.merge(where(payment_requests_count: 0))
      when :not_complete
        scoped.merge(PaymentRequest.complete(false))
      when :complete
        scoped.merge(PaymentRequest.complete(true))
      else
        scoped
      end
    end
  end

  def request_status
    unless payment_request
      "청구전"
    else
      payment_request.request_status
    end
  end

  included do
    has_one :payment_request, as: :basis
    extend ClassMethods
  end
end