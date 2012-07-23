class ChangeUserIdToHrinfoIdToPayments < ActiveRecord::Migration
  def up
    add_column :payments, :hrinfo_id, :integer
    
    Payment.find_each do |payment|
      hrinfo = Hrinfo.find_by_user_id(payment.user_id)

      payment.hrinfo_id = hrinfo.id
      payment.save!
    end  

    remove_column :payments, :user_id
  end

  def down
    add_column :payments, :user_id, :integer

    Payment.find_each do |payment|
      hrinfo = Hrinfo.find(payment.hrinfo_id)

      payment.user_id = hrinfo.user_id
      payment.save!
    end  

    remove_column :payments, :hrinfo_id
  end
end
