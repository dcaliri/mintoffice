class ModifyCompleteOfPaymentRequests < ActiveRecord::Migration
  class PaymentRequest < ActiveRecord::Base; end

  def up
    change_column  :payment_requests, :complete, :boolean, default: false
    PaymentRequest.where(complete: nil).update_all(complete: false)
  end

  def down
    change_column  :payment_requests, :complete, :boolean, default: nil
  end
end
