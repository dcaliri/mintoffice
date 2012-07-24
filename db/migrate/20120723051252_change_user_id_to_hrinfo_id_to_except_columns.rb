class ChangeUserIdToHrinfoIdToExceptColumns < ActiveRecord::Migration
  def up
    add_column :except_columns, :hrinfo_id, :integer

    execute <<-SQL
      UPDATE except_columns
      SET hrinfo_id = (SELECT hrinfos.id
      FROM hrinfos
      WHERE hrinfos.user_id = except_columns.user_id)
    SQL
    
    remove_column :except_columns, :user_id
  end

  def down
    add_column :except_columns, :user_id, :integer

    execute <<-SQL
      UPDATE except_columns
      SET user_id = (SELECT hrinfos.user_id
      FROM hrinfos
      WHERE hrinfos.id = except_columns.hrinfo_id)
    SQL

    remove_column :except_columns, :hrinfo_id
  end
end
