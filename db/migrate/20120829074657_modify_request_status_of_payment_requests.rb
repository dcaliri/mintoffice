class ModifyRequestStatusOfPaymentRequests < ActiveRecord::Migration
  def up
    remove_column :payment_requests, :request_status
    add_column :payment_requests, :complete, :boolean
  end

  def down
    add_column :payment_requests, :request_status, :string
    remove_column :payment_requests, :complete
  end
end
