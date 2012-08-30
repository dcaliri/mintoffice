class AssociatePaymentRequestsToOtherTables < ActiveRecord::Migration
  def change
    add_column :payment_requests, :basis_type, :string
    add_column :payment_requests, :basis_id, :integer
  end
end
