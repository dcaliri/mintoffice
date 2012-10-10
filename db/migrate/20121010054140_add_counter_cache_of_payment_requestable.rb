class AddCounterCacheOfPaymentRequestable < ActiveRecord::Migration
  def up
    add_column :dayworker_taxes, :payment_request_count, :integer, default: 0
    add_column :payment_records, :payment_request_count, :integer, default: 0
    add_column :payrolls, :payment_request_count, :integer, default: 0
    add_column :taxbills, :payment_request_count, :integer, default: 0

    [DayworkerTax, PaymentRecord, Payroll, Taxbill].each do |model|
      model.find_each do |resource|
        if resource.payment_request
          resource.update_column(:payment_request_count, 1)
        end
      end
    end
  end

  def down
    remove_column :dayworker_taxes, :payment_request_count
    remove_column :payment_records, :payment_request_count
    remove_column :payrolls, :payment_request_count
    remove_column :taxbills, :payment_request_count
  end
end
