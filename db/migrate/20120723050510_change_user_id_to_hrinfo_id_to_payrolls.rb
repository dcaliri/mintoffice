class ChangeUserIdToHrinfoIdToPayrolls < ActiveRecord::Migration
  def up
    add_column :payrolls, :hrinfo_id, :integer
    
    Payroll.find_each do |payroll|
      hrinfo = Hrinfo.find_by_user_id(payroll.user_id)

      payroll.hrinfo_id = hrinfo.id
      payroll.save!
    end  

    remove_column :payrolls, :user_id
  end

  def down
    add_column :payrolls, :user_id, :integer

    Payroll.find_each do |payroll|
      hrinfo = Hrinfo.find(payroll.hrinfo_id)

      payroll.user_id = hrinfo.user_id
      payroll.save!
    end  

    remove_column :payrolls, :hrinfo_id
  end
end
