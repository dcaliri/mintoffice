class AssociatePaymentsToPayrolls < ActiveRecord::Migration
  def change
    add_column :payments, :payroll_id, :integer
  end
end
