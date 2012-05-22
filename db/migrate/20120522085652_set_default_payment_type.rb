class SetDefaultPaymentType < ActiveRecord::Migration
  def change
    Payment.find_each do |payment|
      if payment.payment_type.blank?
        payment.payment_type = 'default'
        payment.save!
      end
    end
  end
end
