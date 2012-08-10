class ChangeUserIdToHrinfoIdToPayrolls < ActiveRecord::Migration
  def up
    add_column :payrolls, :hrinfo_id, :integer
    
    execute <<-SQL
      UPDATE payrolls
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = payrolls.user_id)
    SQL

    remove_column :payrolls, :user_id
  end

  def down
    add_column :payrolls, :user_id, :integer

    execute <<-SQL
      UPDATE payrolls
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = payrolls.hrinfo_id)
    SQL

    remove_column :payrolls, :hrinfo_id
  end
end
