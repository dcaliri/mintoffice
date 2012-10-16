class AddCounterCacheOfPaymentRequestable < ActiveRecord::Migration
  def up
    add_column :dayworker_taxes, :payment_requests_count, :integer, default: 0
    add_column :payment_records, :payment_requests_count, :integer, default: 0
    add_column :payrolls, :payment_requests_count, :integer, default: 0
    add_column :taxbills, :payment_requests_count, :integer, default: 0

    [DayworkerTax, PaymentRecord, Payroll, Taxbill].each do |model|
      model.find_each do |resource|
        if resource.payment_request
          resource.update_column(:payment_requests_count, 1)
        end
      end
    end
  end

  def down
    remove_column :dayworker_taxes, :payment_requests_count
    remove_column :payment_records, :payment_requests_count
    remove_column :payrolls, :payment_requests_count
    remove_column :taxbills, :payment_requests_count
  end
end
