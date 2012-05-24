class ModifyPaymentSchedule < ActiveRecord::Migration
  def change
    rename_column :payments, :pay_at, :pay_finish
    add_column :payments, :pay_start, :date

    Payment.find_each do |payment|
      payment.pay_start = payment.pay_finish.prev_month + 1.day
      payment.save!
    end
  end
end
