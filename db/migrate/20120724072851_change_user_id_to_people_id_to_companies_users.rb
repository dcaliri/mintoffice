class ChangeUserIdToPeopleIdToCompaniesUsers < ActiveRecord::Migration
  def up
    add_column :companies_users, :person_id, :integer

    execute <<-SQL
      UPDATE companies_users
      SET person_id = (SELECT users.person_id
      FROM users
      WHERE users.id = companies_users.user_id)
    SQL

    remove_column :companies_users, :user_id
    rename_table :companies_users, :companies_people
  end

  def down
    add_column :companies_people, :user_id, :integer

    execute <<-SQL
      UPDATE companies_people
      SET user_id = (SELECT users.id
      FROM users
      WHERE users.person_id = companies_people.person_id)
    SQL

    remove_column :companies_people, :person_id
    rename_table :companies_people, :companies_users
  end
end
