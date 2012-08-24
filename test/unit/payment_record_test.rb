require 'test_helper'

class PaymentRecordTest < ActiveSupport::TestCase
	fixtures :payment_records

  test "PaymentRecord should create payment_record" do
  	payment_record = PaymentRecord.new
    payment_record.name = "new name"
    assert payment_record.save!
  end

  test "PaymentRecord should update payment_record" do
  	payment_record = PaymentRecord.find(current_payment_record.id)
    payment_record.name = "update name"
    assert payment_record.save!
  end

  test "PaymentRecord should destroy payment_record" do
  	payment_record = PaymentRecord.find(current_payment_record.id)
    assert payment_record.destroy
  end

  private
  def current_payment_record
    @payment_record ||= payment_records(:fixture)
  end
end