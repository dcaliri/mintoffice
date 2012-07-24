class ChangeUserIdToHrinfoIdToPayments < ActiveRecord::Migration
  def up
    add_column :payments, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE payments
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = payments.user_id)
    SQL

    remove_column :payments, :user_id
  end

  def down
    add_column :payments, :user_id, :integer

    execute <<-SQL
      UPDATE payments
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = payments.hrinfo_id)
    SQL

    remove_column :payments, :hrinfo_id
  end
end
